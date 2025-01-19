import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onBoardingSettingsProvider = Provider((ref) {
  return OnboardingSettings(
    sharedPreferences: ref.watch(sharedPrefsProvider),
  );
});

class OnboardingSettings {
  
  SharedPreferences? sharedPreferences;
  static String onboardKey = "onboard_key";

  OnboardingSettings({this.sharedPreferences});

  FutureVoid passOnboarding() async {
    await sharedPreferences!.setBool(onboardKey, false);
    return;
  }

  bool isFirstTime() {
    return sharedPreferences!.getBool(onboardKey) ?? true;
  }

}
