import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static String _token = "";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //user id
  static String get token {
    return _preferences.getString("token") ?? _token;
  }

  static set token(String value) {
    _token = value;
    _preferences.setString("token", value);
  }
}
