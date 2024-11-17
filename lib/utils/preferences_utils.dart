import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static const String onboardingShownKey = 'onboardingShown';

  static Future<void> setOnboardingShown(bool shown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingShownKey, shown);
  }

  static Future<bool> getOnboardingShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingShownKey) ?? true;
  }
}
