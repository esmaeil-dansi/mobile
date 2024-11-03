import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/advertisement.dart';
import 'package:frappe_app/db/dao/advertisement_dao.dart';
import 'package:frappe_app/model/weather.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:frappe_app/widgets/methodes.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart' as g;
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shamsi_date/shamsi_date.dart';

enum FetchNationalStatus { Failed, Success, Error }

class AutService {
  Rx<String> selectedCity = "".obs;
  var weathers = <Weather>[].obs;

  var _shared = GetIt.I.get<SharedPreferencesHelper>();

  var _logger = Logger();
  String phone = "";
  String verifyCode = "";

  var remainCredit = "".obs;

  String sid() => _shared.getString(SID) ?? "";

  String fullName() => _shared.getString(FULL_NAME) ?? "";

  String fullNameChar() => _shared.getString(FULL_NAME_CHAR) ?? "";

  String userId() => _shared.getString(USER_ID) ?? "";

  String userImage() => _shared.getString(USER_IMAGE) ?? "";

  List<String> roles() => _shared.getStringList(ROLES) ?? [];

  bool isDamdar() => roles().contains("دامدار");

  bool isRahbar() => roles().contains("راهبر");

  bool isSarRahbar() => roles().contains("سر راهبر");

  bool isSupplier() => roles().contains("Supplier");

  bool isStorekeeper() => roles().contains("انباردار");

  bool isVisitingTeam() => roles().contains("تیم بازدید کننده");

  bool isVisitingTeamOrIsRahbar() => isVisitingTeam() || isRahbar();

  String getProvince() => _shared.getString(PROVINCE) ?? "";

  String getCity() => _shared.getString(CITY) ?? "";

  void saveSelectedCity(String city) {
    selectedCity.value = city;
    _shared.setString(SELECTED_CITY, city);
  }

  getUserId() {
    return userId();
  }

  String mainUserId() {
    return userId().replaceAll("%40", "@");
  }

  var advDao = GetIt.I.get<AdvertisementDao>();

  Rx<String> getUserImage() => userImage().obs;

  AutService() {
    try {
      Connectivity().onConnectivityChanged.listen((result) {
        if (result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.bluetooth) ||
            result.contains(ConnectivityResult.vpn) ||
            result.contains(ConnectivityResult.other) ||
            result.contains(ConnectivityResult.ethernet) ||
            result.contains(ConnectivityResult.wifi)) {
          checkLoginCertificate();
        }
      });
    } catch (_) {
      _logger.e(_);
    }
  }

  Future<void> fetchRemainCredit() async {
    try {
      remainCredit.value = _shared.getString(REMAIN_CREDIT_KEY_1) ?? "";
      var nationNumber = await fetchCurrentUserNationNumber();
      if (nationNumber != null) {
        final info = await GetIt.I
            .get<HttpService>()
            .get("/api/method/get_remain_credit?username=${nationNumber}");
        final r = info?.data["remain_credit"] ?? "";
        _shared.setString(REMAIN_CREDIT_KEY_1, r);
        remainCredit.value = r;
      }
    } catch (_) {
      _logger.e(_);
    }
  }

  bool needToFetchWeather() {
    return DateTime.now().millisecondsSinceEpoch -
            (_shared.getInt(LAST_FETCH_WEATHER_TIME) ?? 0) >
        6 * 60 * 60 * 1000;
  }

  Future<void> fetchAdvertisement(DateTime dateTime) async {
    try {
      final f = new DateFormat('yyyy-MM-dd').format(dateTime);

      var result = await GetIt.I
          .get<HttpService>()
          .get("/api/method/get_announce?date=$f");

      var sub = (result?.data["response_sub"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      if (sub.isNotEmpty) {
        advDao.save(Advertisement(
          date: f,
          title: sub,
          body: (result?.data["response_txt"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
        ));
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  String _decodePercentEncodedString(String encoded) {
    try {
      List<String> parts = encoded.split('%');
      StringBuffer decoded = StringBuffer();

      for (String part in parts) {
        if (part.isEmpty) continue; // Skip any empty parts

        if (part.length >= 2) {
          // Decode the hexadecimal value
          String hexValue = part.substring(0, 2);
          int charCode = int.parse(hexValue, radix: 16);
          decoded.writeCharCode(charCode);

          if (part.length > 2) {
            // Append the rest of the string if any
            decoded.write(part.substring(2));
          }
        } else {
          decoded.write(part); // If no valid hex value, just append the part
        }
      }

      return utf8.decode(decoded.toString().runes.toList());
    } catch (e) {
      return encoded;
    }
  }

  (String, String) getDate(int j) {
    var date = DateTime.now().add(Duration(days: ((j).ceil())));
    var jalali = Jalali.fromDateTime(date);
    return (
      jalali.month.toString() + "/" + jalali.day.toString(),
      weekdays(jalali.weekDay - 1)
    );
  }

  String weekdays(int j) => ["ش", "ی", "د", "س", "چ", "پ", "ج"][j];

  Future<void> getWeather({required double lat, required double lon}) async {
    try {
      if (needToFetchWeather()) {
        var result = await Dio().get(
            'https://one-api.ir/weather/?action=dailybylocation&token=249726:668cbf97266ea&lat=$lat&lon=$lon');
        if (result.data["status"] == 200) {
          _shared.setInt(
              LAST_FETCH_WEATHER_TIME, DateTime.now().millisecondsSinceEpoch);
          try {
            saveSelectedCity(result.data["result"]["city"]["name"]);
          } catch (e) {}
          _extractWeather(result.data);
          _shared.setString(WAETHER_KEY, json.encode(result.data));
        } else {
          initOldWeather();
        }
      } else {
        initOldWeather();
      }
    } catch (e) {
      initOldWeather();
      _logger.e(e);
    }
  }

  void initOldWeather() {
    try {
      var s = _shared.getString(WAETHER_KEY);
      if (s != null) {
        _extractWeather(json.decode(s));
      }
    } catch (e) {}
  }

  void _extractWeather(dynamic result) {
    var res = <Weather>[];
    List<dynamic> data =
        ((result["result"]["list"]) as List<dynamic>).sublist(0, 5);
    for (int j = 0; j < data.length; j++) {
      var s = data[j];
      var date = getDate(j);
      res.add(Weather(
          temp: (s["temp"]["eve"]).toString(),
          icon: s["weather"][0]["icon"],
          main: s["weather"][0]["main"],
          description: s["weather"][0]["description"],
          date: date.$1,
          w: date.$2));
    }

    weathers.clear();
    weathers.addAll(res);
  }

  Future<bool> checkLoginCertificate() async {
    var res = await login(
        username: _shared.getString(USERNAME) ?? "",
        password: _shared.getString(PASSWORD) ?? "");
    if (res.$1) {
      return true;
    } else {
      var r = DateTime.now().millisecondsSinceEpoch -
              (_shared.getInt(LAST_UPDATE_TIME) ?? 0) <
          24 * 60 * 60 * 1000;
      if (!r && res.$2) {
        _shared.setBool('login', false);
        return false;
      }
      return true;
    }
  }

  Future<(bool, bool)> login({
    required String username,
    required String password,
  }) async {
    try {
      var res = await GetIt.I.get<HttpService>().post("/login",
          FormData.fromMap({"cmd": "login", "usr": username, "pwd": password}));
      if (res?.statusCode == 200) {
        _shared.setInt(LAST_UPDATE_TIME, DateTime.now().millisecondsSinceEpoch);
        String name = _decodePercentEncodedString(res!.data["full_name"]);
        _saveData(
            res.headers["set-cookie"]?.first.split(";").first.split("=").last ??
                "",
            name,
            res.headers["set-cookie"]![2]
                .split(";")
                .first
                .split("=")
                .last
                .toString(),
            res.headers["set-cookie"]![3]
                .split(";")
                .first
                .split("=")
                .last
                .toString(),
            res.headers["set-cookie"]?[4].split(";").first.split("=").last ??
                "");
        _deleteHive(username);
        _shared.setString(USERNAME, username);
        _shared.setString(PASSWORD, password);
        await _getUserRole();
        getPermission();
        _shared.setBool(IsLogin, true);
        return (true, false);
      } else {
        return (false, res?.statusCode == 500);
      }
    } catch (e) {
      _logger.e(e);
    }
    return (false, false);
  }

  Future<void> _getUserRole() async {
    try {
      var res = await GetIt.I.get<HttpService>().post(
            "/api/method/get_user_roles?username=${userId()}",
            FormData.fromMap({}),
          );

      final items = (res?.data["role"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      _shared.setStringList(ROLES, items);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> getShopInfo() async {
    try {} catch (e) {
      _logger.e(e);
    }
  }

  Future<void> _saveData(String sid, String full_name, String full_name_char,
      String user_id, String user_image) async {
    _shared.setString(SID, sid);
    _shared.setString(FULL_NAME, full_name);
    _shared.setString(USER_ID, user_id);
    _shared.setString(USER_IMAGE, user_image);
    _shared.setString(FULL_NAME_CHAR, full_name_char);
  }

  Future<String> sendSms(String phoneNumber) async {
    try {
      phone = phoneNumber;
      var res = await await GetIt.I.get<HttpService>().post(
          "/api/method/send_signup_code?mobile=$phoneNumber",
          FormData.fromMap({}));

      return res?.data?["code"] == "2000"
          ? ""
          : res?.data["message"] ?? "خطایی رخ داده است";
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }

  Future<bool> supplierInfoSubmitted() async {
    try {
      if ((_shared.getBool(SUPPLIER_INFO_KEY)) ?? false) {
        return true;
      }
      var res = await GetIt.I
          .get<HttpService>()
          .get("/api/method/get_supplier_doc?name_user=$USER_ID");
      if (((res?.data["res"]["name"]) ?? "").toString().isNotEmpty) {
        _shared.setBool(SUPPLIER_INFO_KEY, true);
        return true;
      }
      return false;
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<bool> submitSupplierInfo(
      {required String image,
      required String cardNumber,
      required String name}) async {
    try {
      Progressbar.showProgress();
      var imageUri = await GetIt.I
          .get<FileService>()
          .uploadFile(image, "User", docname: "new-message-1");
      if (imageUri != null && imageUri.isNotEmpty) {
        var res = await GetIt.I.get<HttpService>().post(
            "/api/method/add_supp_doc",
            FormData.fromMap({
              "name": getUserId(),
              "custom_account_number": cardNumber,
              "custom_id_card": imageUri
            }));
        Progressbar.dismiss();
        if (res?.statusCode == 200) {
          _shared.setBool(SUPPLIER_INFO_KEY, true);
          Fluttertoast.showToast(msg: res?.data["message"]);
          return true;
        }
      }
      Progressbar.dismiss();
      return false;
    } catch (e) {
      _logger.e(e);
    }
    Progressbar.dismiss();
    return false;
  }

  Future<void> sendReport(String text) async {
    try {
      GetIt.I.get<HttpService>().post(
          "https://icasp.ir/api/method/add_suggestions?user_id=${userId()}&suggest_text=$text",
          FormData());
    } catch (_) {}
  }

  Future<String?> fetchNationNumber(String userId) async {
    try {
      var res = await GetIt.I
          .get<HttpService>()
          .get("/api/method/get_user_info?user_id=$userId");
      return res?.data?["res"][0]["username"].toString();
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<String?> fetchCurrentUserNationNumber() async {
    try {
      if (_shared.getString(CURRENT_USER_NATIONAL_ID) != null) {
        return _shared.getString(CURRENT_USER_NATIONAL_ID)!;
      }
      var id = await fetchNationNumber(getUserId());
      if (id != null) {
        _shared.setString(CURRENT_USER_NATIONAL_ID, id);
        return id;
      }
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<String?> fetchMobile(String userId) async {
    try {
      var res = await GetIt.I
          .get<HttpService>()
          .get("/api/method/get_user_info?user_id=$userId");
      return res?.data?["res"][0]["mobile_no"];
    } catch (e) {
      _logger.e(e);
    }
    return null;
  }

  Future<void> getPermission() async {
    try {
      var res = await GetIt.I.get<HttpService>().post(
          "/api/method/get_user_permissions?username=${userId()}",
          FormData.fromMap({}));
      var map = res?.data as Map<String, dynamic>;
      if (map.containsKey("for_value")) {
        var province = map["for_value"]?[0];
        if (province != null) {
          _shared.setString(PROVINCE, province);
        }
        var city = map["for_value"]?[1];
        if (city != null) {
          _shared.setString(CITY, city);
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<String> sendVerificationCode(String verificationCode) async {
    try {
      verifyCode = verificationCode;
      var res = await await GetIt.I.get<HttpService>().post(
          "/api/method/confirm_signup_code?mobile=$phone&verify_code=$verificationCode",
          FormData.fromMap({}));
      return res?.data?["code"] == "2000"
          ? ""
          : res?.data["message"] ?? "خطایی رخ داده است";
    } catch (e) {
      _logger.e(e);
    }
    return 'خطایی رخ داده است';
  }

  get getName {
    return _shared.getString(NAME) ?? "";
  }

  get getLastName {
    return _shared.getString(LAST_NAME) ?? "";
  }

  get getUsername {
    return _shared.getString(USER_NAME) ?? "";
  }

  Future<(String, String, String)> getFirstNameAndLastName() async {
    try {
      var res = await GetIt.I.get<HttpService>().get(
            "/api/method/frappe.desk.form.load.getdoc?doctype=User&name=${userId()}&_=1718056741467",
          );
      var name = res?.data['docs'][0]['first_name'];
      var lastName = res?.data["docs"][0]["last_name"];
      var username = res?.data["docs"][0]["username"];
      _shared.setString(NAME, name);
      _shared.setString(LAST_NAME, lastName);
      _shared.setString(USER_NAME, username);
      return (name.toString(), lastName.toString(), username.toString());
    } catch (e) {
      _logger.e(e);
      return ("", "", "");
    }
  }

  Future<FetchNationalStatus> nationalCodeIsAvailable(String nationCode) async {
    try {
      var result = await GetIt.I
          .get<HttpService>()
          .get("/api/method/get_app_mobile?username=$nationCode");
      if (result?.data["res"] == 4000) {
        return FetchNationalStatus.Success;
      }
      return FetchNationalStatus.Failed;
    } catch (e) {
      return FetchNationalStatus.Error;
    }
  }

  Future<bool> sendInfo(
      {required String password,
      required String nationalId,
      required String province,
      required String bio,
      required String firstname,
      required bool tamin,
      required String lastname}) async {
    try {
      if (tamin) {
        var res = await await GetIt.I.get<HttpService>().post(
            "/api/method/create_taminuser?mobile=$phone&new_password=$password&verify_code=$verifyCode&national_id=$nationalId"
            "&province=$province&bio=$bio&first_name=$firstname&last_name=$lastname",
            FormData.fromMap({}));
        Progressbar.dismiss();
        if (res?.statusCode == 200) {
          return true;
        } else {
          showErrorMessage(res?.data["_server_messages"]);
          return false;
        }
      } else {
        var res = await await GetIt.I.get<HttpService>().post(
            "/api/method/create_damdar?mobile=$phone&new_password=$password&verify_code=$verifyCode&national_id=$nationalId"
            "&province=$province&bio=$bio&first_name=$firstname&last_name=$lastname",
            FormData.fromMap({}));
        Progressbar.dismiss();
        if (res?.statusCode == 200) {
          return true;
        } else {
          showErrorMessage(res?.data["_server_messages"]);
          return false;
        }
      }
    } catch (e) {
      Progressbar.dismiss();
      _logger.e(e);
    }
    return false;
  }

  Future<bool> changeProfileAvatar(String path) async {
    try {
      var result = await GetIt.I.get<FileService>().uploadFile(path, "User",
          docname: getUserId(), fieldname: "user_image");
      if (result != null) {
        var setProfileInfo = await GetIt.I.get<HttpService>().post(
            "/api/method/frappe.desk.page.user_profile.user_profile.update_profile_info",
            FormData.fromMap({
              "profile_info": json.encode({"user_image": result})
            }));
        _shared.setString(USER_IMAGE, result);
        return setProfileInfo?.statusCode == 200;
      }
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<void> logout() async {
    _shared.clearAllWithPrefix();
    _shared.setBool(IsLogin, false);
  }

  Future<void> _deleteHive(String username) async {
    try {
      var u = _shared.getString(USERNAME);
      if (u != null && u.isNotEmpty && u != username) {
        Hive.deleteFromDisk();
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<File?> downloadAvatar(String uri) async {
    var result = await GetIt.I.get<HttpService>().get("$uri");
    if (result != null) {
      return File.fromRawPath(result.data);
    }
    return null;
  }

  Future<String> forgetPassword(String username) async {
    try {
      var res = await await GetIt.I.get<HttpService>().post(
          "/api/method/send_forget_code?username=$username",
          FormData.fromMap({}));
      return res?.data["code"] == "2000" ? "" : res?.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }

  Future<String> setForgetPassCode(String code, String username) async {
    try {
      var res = await await GetIt.I.get<HttpService>().post(
          "/api/method/confirm_entry_code?username=$username&verify_code=$code",
          FormData.fromMap({}));
      return res?.data["code"] == "2000" ? "" : res?.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }

  Future<String> resetPassword(
      String code, String username, String password) async {
    try {
      var res = await await GetIt.I.get<HttpService>().post(
          "/api/method/change_password?username=$username&password=$password&verify_code=$code",
          FormData.fromMap({}));
      return res?.data["code"] == "2000" ? "" : res?.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }
}
