import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frappe_app/db/advertisement.dart';
import 'package:frappe_app/db/dao/advertisement_dao.dart';
import 'package:frappe_app/model/weather.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/methodes.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart' as g;
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutService {
  String SID = "sid";
  String FULL_NAME = "full_name";
  String FULL_NAME_CHAR = "full_name_char";
  String USER_ID = "user_id";
  String ROLES = "roles";
  String USER_IMAGE = "user_image";
  String PASSWORD = "user_image";
  String NAME = "name";
  String LAST_NAME = "last_name";
  String USER_NAME = "user_name";
  String PROVINCE = "province";
  String CITY = "city";
  String SELECTED_CITY = "selected_city";
  String WAETHER_KEY = "WAETHER_KEY";

  var weathers = <Weather>[].obs;

  var _logger = Logger();
  String phone = "";
  String verifyCode = "";

  String _sid = "";
  String _full_name = "";
  String _full_name_char = "";
  String _user_id = "";
  final _user_image = "".obs;

  List<String> _roles = [];

  bool isDamdar() => this._roles.contains("دامدار");

  bool isRahbar() => this._roles.contains("راهبر");

  bool isSarRahbar() => this._roles.contains("سر راهبر");

  bool isSupplier() => this._roles.contains("Supplier");

  String getProvince() => _sharedPreferences.getString(PROVINCE) ?? "";

  String getCity() => _sharedPreferences.getString(CITY) ?? "";

  String getSelectedCity() => _sharedPreferences.getString(SELECTED_CITY) ?? "";

  void saveSelectedCity(String city) =>
      _sharedPreferences.setString(SELECTED_CITY, city);

  late SharedPreferences _sharedPreferences;

  getSid() => _sid;

  getFullName() => _full_name;

  getFullNameChar() => _full_name_char;

  getUserId() {
    return _user_id;
  }

  var advDao = GetIt.I.get<AdvertisementDao>();

  Rx<String> getUserImage() => _user_image;

  AutService() {
    init();
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

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sid = _sharedPreferences.getString(SID) ?? "";
    _full_name = _sharedPreferences.getString(FULL_NAME) ?? "";
    _full_name_char = _sharedPreferences.getString(FULL_NAME_CHAR) ?? "";
    _user_id = _sharedPreferences.getString(USER_ID) ?? "";
    _user_image.value = _sharedPreferences.getString(USER_IMAGE) ?? "";
    _roles = _sharedPreferences.getStringList(ROLES) ?? [];
    GetIt.I.get<ShopService>().fetchShopInfo(_user_id);
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
    var date = DateTime.now().add(Duration(days: ((j / 8).ceil())));
    var jalali = Jalali.fromDateTime(date);
    return (
      jalali.month.toString() + "/" + jalali.day.toString(),
      weekdays(jalali.weekDay - 1)
    );
  }

  String weekdays(int j) => ["ش", "ی", "د", "س", "چ", "پ", "ج"][j];

  Future<void> getWeather() async {
    try {
      var res = <Weather>[];
      var result = await Dio()
          .get('https://api.codebazan.ir/weather/?city=${getSelectedCity()}');

      _sharedPreferences.setString(WAETHER_KEY, json.encode(result.data));
      int i = 0;
      while (i <= 40) {
        try {
          var s = getDate(i);
          res.add(Weather(
              temp: result.data["list"][i]["main"]["temp"],
              icon: result.data["list"][i]["weather"][0]["icon"],
              main: result.data["list"][i]["weather"][0]["main"],
              description: result.data["list"][i]["weather"][0]["description"],
              date: s.$1,
              w: s.$2));
        } catch (e) {
          print("e");
        }
        i = i + 8;
      }
      weathers.clear();
      weathers.addAll(res);
    } catch (e) {
      try {
        var s = _sharedPreferences.getString(WAETHER_KEY);
        if (s != null) {
          var result = json.decode(s);
          var res = <Weather>[];
          int i = 0;
          while (i <= 40) {
            try {
              var s = getDate(i);
              res.add(Weather(
                  temp: result["list"][i]["main"]["temp"],
                  icon: result["list"][i]["weather"][0]["icon"],
                  main: result["list"][i]["weather"][0]["main"],
                  description: result["list"][i]["weather"][0]
                      ["description"],
                  date: s.$1,
                  w: s.$2));
            } catch (e) {
              print("e");
            }
            i = i + 8;
          }
          weathers.clear();
          weathers.addAll(res);
        }
      } catch (e) {}

      _logger.e(e);
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      var res = await GetIt.I.get<HttpService>().post("/login",
          FormData.fromMap({"cmd": "login", "usr": username, "pwd": password}));
      if (res == null) {
        return false;
      }

      String name = _decodePercentEncodedString(res.data["full_name"]);
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
          res.headers["set-cookie"]?[4].split(";").first.split("=").last ?? "");
      await _getUserRole();
      getPermission();
      GetIt.I.get<ShopService>().fetchShopInfo(_user_id);
      return res.statusCode == 200;
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<void> _getUserRole() async {
    try {
      var res = await GetIt.I.get<HttpService>().post(
            "/api/method/get_user_roles?username=$_user_id",
            FormData.fromMap({}),
          );

      _roles = (res?.data["role"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      _sharedPreferences.setStringList(ROLES, _roles);
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
    _sid = sid;
    _full_name = full_name;
    _full_name_char = full_name_char;
    _user_id = user_id;
    _user_image.value = user_image;
    _sharedPreferences.setString(SID, _sid);
    _sharedPreferences.setString(FULL_NAME, _full_name);
    _sharedPreferences.setString(USER_ID, _user_id);
    _sharedPreferences.setString(USER_IMAGE, _user_image.value);
    _sharedPreferences.setString(FULL_NAME_CHAR, full_name_char);
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

  Future<void> getPermission() async {
    try {
      var res = await GetIt.I.get<HttpService>().post(
          "/api/method/get_user_permissions?username=$_user_id",
          FormData.fromMap({}));
      var map = res?.data as Map<String, dynamic>;
      if (map.containsKey("for_value")) {
        var province = map["for_value"]?[0];
        if (province != null) {
          _sharedPreferences.setString(PROVINCE, province);
        }
        var city = map["for_value"]?[1];
        if (city != null) {
          _sharedPreferences.setString(CITY, city);
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
    return _sharedPreferences.get(NAME) ?? "";
  }

  get getLastName {
    return _sharedPreferences.get(LAST_NAME) ?? "";
  }

  get getUsername {
    return _sharedPreferences.get(USER_NAME) ?? "";
  }

  Future<(String, String, String)> getFirstNameAndLastName() async {
    try {
      var res = await GetIt.I.get<HttpService>().get(
            "/api/method/frappe.desk.form.load.getdoc?doctype=User&name=${_user_id}&_=1718056741467",
          );
      var name = res?.data['docs'][0]['first_name'];
      var lastName = res?.data["docs"][0]["last_name"];
      var username = res?.data["docs"][0]["username"];
      _sharedPreferences.setString(NAME, name);
      _sharedPreferences.setString(LAST_NAME, lastName);
      _sharedPreferences.setString(USER_NAME, username);
      return (name.toString(), lastName.toString(), username.toString());
    } catch (e) {
      _logger.e(e);
      return ("", "", "");
    }
  }

  Future<bool> sendInfo(
      {required String password,
      required String nationalId,
      required String province,
      required String bio,
      required String firstname,
      required bool damdar,
      required String lastname}) async {
    try {
      if (damdar) {
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
      } else {
        var res = await await GetIt.I.get<HttpService>().post(
            "/api/method/create_user?mobile=$phone&new_password=$password&verify_code=$verifyCode&national_id=$nationalId"
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
        _user_image.value = result;
        _sharedPreferences.setString(USER_IMAGE, result);
        return setProfileInfo?.statusCode == 200;
      }
    } catch (e) {
      _logger.e(e);
    }
    return false;
  }

  Future<void> logout() async {
    await _sharedPreferences.clear();
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
