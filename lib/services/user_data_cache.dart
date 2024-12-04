import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

final userDataCacheProvider = Provider((ref) {
  return UserDataCache(
    userBox: Hive.box('user')
  );
});

class UserDataCache {
  Box<User>? userBox;
  static String userKey = "user_data";

  UserDataCache({this.userBox});

  FutureVoid saveUserData(User user) async {
    await userBox!.put(userKey, user);
  }

  User? getUserData() {
    return userBox!.get(userKey);
  }

  FutureVoid clearUserData() async {
    await userBox!.delete(userKey);
  }
}
