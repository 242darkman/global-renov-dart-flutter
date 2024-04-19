import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('authToken', token);
  }

  static String? getToken() {
    return _prefs?.getString('authToken');
  }

  static Future<void> clearToken() async {
    await _prefs?.remove('authToken');
  }
}
