import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static SharedPreferenceUtil? _instance;

  SharedPreferenceUtil._();

  static SharedPreferenceUtil get instance =>
      _instance ??= SharedPreferenceUtil._();

  Future<String?> getStringPreference(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  setPreferenceValue(String key, var value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }
}
