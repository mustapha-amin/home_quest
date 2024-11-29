import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/providers.dart';
import '../core/typedefs.dart';

final userTypePrefsProvider = Provider((ref) {
  return UserTypePrefs(
    sharedPreferences: ref.watch(sharedPrefsProvider),
  );
});

class UserTypePrefs {
  
  SharedPreferences? sharedPreferences;
  static String userTypeKey = "userType";

  UserTypePrefs({this.sharedPreferences});

  FutureVoid saveUserType({required bool isACLient}) async {
    await sharedPreferences!.setBool(userTypeKey, isACLient);
  }

  bool userIsAClient() {
    return sharedPreferences!.getBool(userTypeKey) ?? true;
  }

}
