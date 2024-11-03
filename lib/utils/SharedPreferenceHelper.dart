import 'package:frappe_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurrentUser { USER1, USER2 }

class SharedPreferencesHelper {
  String _prefix = "";

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _prefix =
        _sharedPreferences.getString(USER_PREFIX) ?? CurrentUser.USER1.name;
  }

  String get prefix => _prefix;

  void changeUser(CurrentUser current) {
    _prefix = current.name;
    _sharedPreferences.setString(USER_PREFIX, _prefix);
  }

  bool userIsLogin(CurrentUser current) {
    return _sharedPreferences.getBool('${current.name}${IsLogin}') ?? false;
  }

  bool isLogin() {
    if (_sharedPreferences.getBool('$_prefix$IsLogin') ?? false) {
      return true;
    } else {
      var u = getCurrentUser();
      var c = CurrentUser.USER1;
      if (u == CurrentUser.USER1) {
        c = CurrentUser.USER2;
      }
      if (_sharedPreferences.getBool('${c.name}$IsLogin') ?? false) {
        changeUser(c);
        return true;
      }
    }
    return false;
  }

  String getUserInfo(CurrentUser current) {
    return _sharedPreferences.getString('${current.name}${FULL_NAME}') ?? "";
  }

  String getUserImage(CurrentUser current) {
    return _sharedPreferences.getString('${current.name}${USER_IMAGE}') ?? "";
  }

  CurrentUser getCurrentUser() {
    if (_prefix == CurrentUser.USER1.name) {
      return CurrentUser.USER1;
    }
    return CurrentUser.USER2;
  }

  CurrentUser getAnotherUser() {
    if (_prefix == CurrentUser.USER1.name) {
      return CurrentUser.USER2;
    }
    return CurrentUser.USER1;
  }

  // Helper to format key with prefix
  String _formatKey(String key) => '$_prefix$key';

  // Save a String
  void setString(String key, String value) {
    _sharedPreferences.setString(_formatKey(key), value);
  }

  // Retrieve a String
  String? getString(String key) {
    return _sharedPreferences.getString(_formatKey(key));
  }

  // Remove a value
  void remove(String key) {
    _sharedPreferences.remove(_formatKey(key));
  }

  // Save an integer
  void setInt(String key, int value) {
    _sharedPreferences.setInt(_formatKey(key), value);
  }

  // Retrieve an integer
  int? getInt(String key) {
    return _sharedPreferences.getInt(_formatKey(key));
  }

  List<String>? getStringList(String key) {
    return _sharedPreferences.getStringList(_formatKey(key));
  }

  void setStringList(String key, List<String> values) {
    _sharedPreferences.setStringList(_formatKey(key), values);
  }

  // Save a boolean
  void setBool(String key, bool value) {
    _sharedPreferences.setBool(_formatKey(key), value);
  }

  // Retrieve a boolean
  bool? getBool(String key) {
    return _sharedPreferences.getBool(_formatKey(key));
  }

  // Clear all values with the current prefix
  void clearAllWithPrefix() async {
    final keys = _sharedPreferences.getKeys();
    for (String key in keys) {
      if (key.startsWith(_prefix)) {
        await _sharedPreferences.remove(key);
      }
    }

  }
}
