import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frappe_app/model/weather.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:get/get.dart' as g;
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
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

  var weathers = <Weather>[].obs;

  var _logger = Logger();
  String phone = "";
  String verifyCode = "";
  final _dio = Dio(BaseOptions(baseUrl: "https://icasp.ir"));

  String _sid = "";
  String _full_name = "";
  String _full_name_char = "";
  String _user_id = "";
  final _user_image = "".obs;

  List<String> _roles = [];

  bool isDamdar() => this._roles.contains("دامدار");

  bool isRahbar() => this._roles.contains("راهبر");

  bool isSarRahbar() => this._roles.contains("سر راهبر");

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

  Rx<String> getUserImage() => _user_image;

  AutService() {
    init();
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sid = _sharedPreferences.getString(SID) ?? "";
    _full_name = _sharedPreferences.getString(FULL_NAME) ?? "";
    _full_name_char = _sharedPreferences.getString(FULL_NAME_CHAR) ?? "";
    _user_id = _sharedPreferences.getString(USER_ID) ?? "";
    _user_image.value = _sharedPreferences.getString(USER_IMAGE) ?? "";
    _roles = _sharedPreferences.getStringList(ROLES) ?? [];
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

  String getDate(int j) {
    var date = DateTime.now().add(Duration(days: ((j / 8).ceil())));
    var jalali = Jalali.fromDateTime(date);
    return jalali.month.toString() + "/" + jalali.day.toString();
  }

  Future<List<Weather>> getWeather() async {
    try {
      var res = <Weather>[];
      var result = await Dio()
          .get('https://api.codebazan.ir/weather/?city=${getSelectedCity()}');

      int i = 0;
      while (i <= 40) {
        try {
          res.add(Weather(
              temp: result.data["list"][i]["main"]["temp"],
              icon: result.data["list"][i]["weather"][0]["icon"],
              main: result.data["list"][i]["weather"][0]["main"],
              description: result.data["list"][i]["weather"][0]["description"],
              date: getDate(i)));
        } catch (e) {}
        i = i + 8;
      }
      weathers.clear();
      weathers.addAll(res);
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      var res = await _dio.post("/login",
          data: FormData.fromMap(
              {"cmd": "login", "usr": username, "pwd": password}));

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
      var res =
          await _dio.post("/api/method/send_signup_code?mobile=$phoneNumber");

      return res.data?["code"] == "2000"
          ? ""
          : res.data["message"] ?? "خطایی رخ داده است";
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
      var res = await _dio.post(
          "/api/method/confirm_signup_code?mobile=$phone&verify_code=$verificationCode");
      return res.data?["code"] == "2000"
          ? ""
          : res.data["message"] ?? "خطایی رخ داده است";
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
          FormData.fromMap(
              {'doctype': 'User', 'name': _user_id, '_': 1718056741467}));
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

  Future<bool> editProfile(
      {required String name,
      required String lName,
      required String username}) async {
    try {
      var result = await GetIt.I.get<HttpService>().post(
          "/api/method/frappe.desk.form.save.savedocs",
          FormData.fromMap({
            "doc": json.encode({
              "name": "2050433931@icasp.ir",
              "owner": "Guest",
              "creation": "2024-05-17 01:13:28.500004",
              "modified": "2024-06-11 01:54:20.412433",
              "modified_by": "2050433931@icasp.ir",
              "docstatus": 0,
              "idx": 24,
              "enabled": 1,
              "email": "2050433931@icasp.ir",
              "first_name": "اسماعیل",
              "middle_name": "4444r4",
              "last_name": "دانسی 4",
              "full_name": "اسماعیل دانسی",
              "username": "2050433931",
              "language": "fa",
              "time_zone": "Asia/Tehran",
              "send_welcome_email": 1,
              "unsubscribed": 0,
              "user_image":
                  "/files/datauser0io.frappe.frappe_mobilecache69da19b6-a803-47bb-b541-e3d66714ee2e8429288656320640712.jpg",
              "module_profile": "مهمان",
              "mobile_no": "09114583949",
              "mute_sounds": 0,
              "desk_theme": "Light",
              "new_password": "0Aa12345678",
              "logout_all_sessions": 0,
              "reset_password_key": "1duGVOA56gkgjCaKhxhXclx0FU31YPNf",
              "last_reset_password_key_generated_on":
                  "2024-05-17 01:13:30.004148",
              "document_follow_notify": 0,
              "document_follow_frequency": "Daily",
              "follow_created_documents": 0,
              "follow_commented_documents": 0,
              "follow_liked_documents": 0,
              "follow_assigned_documents": 0,
              "follow_shared_documents": 0,
              "thread_notify": 1,
              "send_me_a_copy": 0,
              "allowed_in_mentions": 1,
              "simultaneous_sessions": 1,
              "last_ip": "91.133.162.127",
              "login_after": 0,
              "last_active": "2024-06-11 01:25:17.971215",
              "login_before": 0,
              "bypass_restrict_ip_check_if_2fa_enabled": 0,
              "last_login": "2024-06-11 01:25:07.197350",
              "last_known_versions":
                  "{\"frappe\": {\"title\": \"Frappe Framework\", \"description\": \"Full stack web framework with Python, Javascript, MariaDB, Redis, Node\", \"branch\": \"develop\", \"branch_version\": \"15.x.x-develop ()\", \"version\": \"15.0.0-dev\"}, \"erpnext\": {\"title\": \"ERPNext\", \"description\": \"ERP made simple\", \"branch\": \"develop\", \"branch_version\": \"14.x.x-develop ()\", \"version\": \"15.0.0-dev\"}, \"business_theme_v14\": {\"title\": \"Business Theme V14\", \"description\": \"Business Theme for ERPNext / Frappe\", \"branch\": \"main\", \"version\": \"0.0.1\"}, \"sundae_theme\": {\"title\": \"Sundae Theme\", \"description\": \"multi themes for frappe & erpnext apps\", \"branch\": \"master\", \"version\": \"0.0.1\"}}",
              "onboarding_status":
                  "{\"Main Workspace Tour\":{\"is_complete\":true}}",
              "doctype": "User",
              "defaults": [],
              "social_logins": [
                {
                  "name": "322456ba0b",
                  "owner": "Guest",
                  "creation": "2024-05-17 01:13:29.461297",
                  "modified": "2024-06-11 01:54:20.412433",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 1,
                  "provider": "frappe",
                  "userid": "46142bcd53ea31937b65b87ab402b8a4360be61",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "social_logins",
                  "parenttype": "User",
                  "doctype": "User Social Login"
                }
              ],
              "block_modules": [
                {
                  "name": "55f982d9b7",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.105997",
                  "modified": "2024-06-11 01:54:21.105997",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 1,
                  "module": "Accounts",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "64488476d4",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.160687",
                  "modified": "2024-06-11 01:54:21.160687",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 2,
                  "module": "Assets",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "bf10002d8e",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.161502",
                  "modified": "2024-06-11 01:54:21.161502",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 3,
                  "module": "Automation",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "00e23cdd02",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.162301",
                  "modified": "2024-06-11 01:54:21.162301",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 4,
                  "module": "Bulk Transaction",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "f1372d9fc5",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.163103",
                  "modified": "2024-06-11 01:54:21.163103",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 5,
                  "module": "Business Theme V14",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "d6df9ebe20",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.164134",
                  "modified": "2024-06-11 01:54:21.164134",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 6,
                  "module": "Buying",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "48f668f5aa",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.165459",
                  "modified": "2024-06-11 01:54:21.165459",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 7,
                  "module": "CRM",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "62de1004f6",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.166897",
                  "modified": "2024-06-11 01:54:21.166897",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 8,
                  "module": "Communication",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "8ee859c731",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.168127",
                  "modified": "2024-06-11 01:54:21.168127",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 9,
                  "module": "Contacts",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "686c4f1a0b",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.168916",
                  "modified": "2024-06-11 01:54:21.168916",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 10,
                  "module": "Core",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "ad059924e2",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.169708",
                  "modified": "2024-06-11 01:54:21.169708",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 11,
                  "module": "Custom",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "979924138a",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.170463",
                  "modified": "2024-06-11 01:54:21.170463",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 12,
                  "module": "Desk",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "7b511e2db0",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.171266",
                  "modified": "2024-06-11 01:54:21.171266",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 13,
                  "module": "E-commerce",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "35230c98c6",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.172544",
                  "modified": "2024-06-11 01:54:21.172544",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 14,
                  "module": "ERPNext Integrations",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "fb96ea84f1",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.173351",
                  "modified": "2024-06-11 01:54:21.173351",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 15,
                  "module": "Email",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "84a3d18b73",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.174104",
                  "modified": "2024-06-11 01:54:21.174104",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 16,
                  "module": "Geo",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "d4094699fc",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.175300",
                  "modified": "2024-06-11 01:54:21.175300",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 17,
                  "module": "Integrations",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "cd01b9e3ce",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.176126",
                  "modified": "2024-06-11 01:54:21.176126",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 18,
                  "module": "Maintenance",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "e2006489e9",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.176903",
                  "modified": "2024-06-11 01:54:21.176903",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 19,
                  "module": "Manufacturing",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "030716385d",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.178058",
                  "modified": "2024-06-11 01:54:21.178058",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 20,
                  "module": "PardisSetad",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "c83f6b0bd0",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.178883",
                  "modified": "2024-06-11 01:54:21.178883",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 21,
                  "module": "Portal",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "fd5b6949fc",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.179675",
                  "modified": "2024-06-11 01:54:21.179675",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 22,
                  "module": "Printing",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "cfe532d0be",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.180433",
                  "modified": "2024-06-11 01:54:21.180433",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 23,
                  "module": "Projects",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "763eb3ae26",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.181669",
                  "modified": "2024-06-11 01:54:21.181669",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 24,
                  "module": "Quality Management",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "2aae55de00",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.182436",
                  "modified": "2024-06-11 01:54:21.182436",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 25,
                  "module": "Regional",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "fc3888becc",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.183176",
                  "modified": "2024-06-11 01:54:21.183176",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 26,
                  "module": "Selling",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "3622ef200a",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.183922",
                  "modified": "2024-06-11 01:54:21.183922",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 27,
                  "module": "Setup",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "aa485e3826",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.184692",
                  "modified": "2024-06-11 01:54:21.184692",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 28,
                  "module": "Social",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "0ff8110b6b",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.185468",
                  "modified": "2024-06-11 01:54:21.185468",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 29,
                  "module": "Stock",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "20776231f7",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.186768",
                  "modified": "2024-06-11 01:54:21.186768",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 30,
                  "module": "Subcontracting",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "dc2ed80c9d",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.187516",
                  "modified": "2024-06-11 01:54:21.187516",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 31,
                  "module": "Support",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "1945b26abb",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.188748",
                  "modified": "2024-06-11 01:54:21.188748",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 32,
                  "module": "Telephony",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "e517678f7b",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.191553",
                  "modified": "2024-06-11 01:54:21.191553",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 33,
                  "module": "Utilities",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "a93495713a",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.192430",
                  "modified": "2024-06-11 01:54:21.192430",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 34,
                  "module": "Website",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "424994afbe",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.193212",
                  "modified": "2024-06-11 01:54:21.193212",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 35,
                  "module": "Workflow",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                },
                {
                  "name": "44b7fa3404",
                  "owner": null,
                  "creation": "2024-06-11 01:54:21.194614",
                  "modified": "2024-06-11 01:54:21.194614",
                  "modified_by": "2050433931@icasp.ir",
                  "docstatus": 0,
                  "idx": 36,
                  "module": "gtpardis",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "block_modules",
                  "parenttype": "User",
                  "doctype": "Block Module"
                }
              ],
              "user_emails": [],
              "roles": [
                {
                  "name": "1e21eef8b4",
                  "owner": "Guest",
                  "creation": "2024-05-17 01:13:28.500004",
                  "modified": "2024-05-17 01:13:30.547359",
                  "modified_by": "Guest",
                  "docstatus": 0,
                  "idx": 1,
                  "role": "کاربر مهمان",
                  "parent": "2050433931@icasp.ir",
                  "parentfield": "roles",
                  "parenttype": "User",
                  "doctype": "Has Role"
                }
              ],
              "__onload": {
                "all_modules": [
                  "Accounts",
                  "Assets",
                  "Automation",
                  "Bulk Transaction",
                  "Business Theme V14",
                  "Buying",
                  "CRM",
                  "Communication",
                  "Contacts",
                  "Core",
                  "Custom",
                  "Desk",
                  "E-commerce",
                  "ERPNext Integrations",
                  "Email",
                  "Geo",
                  "Integrations",
                  "Maintenance",
                  "Manufacturing",
                  "Pardis",
                  "PardisSetad",
                  "Portal",
                  "Printing",
                  "Projects",
                  "Quality Management",
                  "Regional",
                  "Selling",
                  "Setup",
                  "Social",
                  "Stock",
                  "Subcontracting",
                  "Sundae Theme",
                  "Support",
                  "Telephony",
                  "Utilities",
                  "Website",
                  "Workflow",
                  "gtpardis"
                ]
              },
              "user_type": "System User",
              "__unsaved": 1
            }),
            "action": 'Save'
          }));
      return result?.statusCode == 200;
    } catch (e) {
      _logger.e(e);
    }
    return false;
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
        var res = await _dio.post(
            "/api/method/create_damdar?mobile=$phone&new_password=$password&verify_code=$verifyCode&national_id=$nationalId"
            "&province=$province&bio=$bio&first_name=$firstname&last_name=$lastname");
        return res.statusCode == 200;
      } else {
        var res = await _dio.post(
            "/api/method/create_user?mobile=$phone&new_password=$password&verify_code=$verifyCode&national_id=$nationalId"
            "&province=$province&bio=$bio&first_name=$firstname&last_name=$lastname");
        return res.statusCode == 200;
      }
    } catch (e) {
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
    var result = await GetIt.I.get<HttpService>().get("$uri", FormData());
    if (result != null) {
      return File.fromRawPath(result.data);
    }
    return null;
  }

  Future<String> forgetPassword(String username) async {
    try {
      var res =
          await _dio.post("/api/method/send_forget_code?username=$username");
      return res.data["code"] == "2000" ? "" : res.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }

  Future<String> setForgetPassCode(String code, String username) async {
    try {
      var res = await _dio.post(
          "/api/method/confirm_entry_code?username=$username&verify_code=$code");
      return res.data["code"] == "2000" ? "" : res.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }

  Future<String> resetPassword(
      String code, String username, String password) async {
    try {
      var res = await _dio.post(
          "/api/method/change_password?username=$username&password=$password&verify_code=$code");
      return res.data["code"] == "2000" ? "" : res.data["message"];
    } catch (e) {
      _logger.e(e);
    }
    return "خطایی رخ داده است";
  }
}
