import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../features/user setup/repository/user_data_repository.dart';

final userDataCacheProvider = Provider((ref) {
  final userBoxProvider = ref.watch(hiveProvider);
  final userDataRepo = ref.watch(userDataRepoProvider);
  return UserDataCache(
    userBox: userBoxProvider,
    userDataRepository: userDataRepo,
  );
});

class UserDataCache {
  Box<User> userBox;
  UserDataRepository userDataRepository;
  static String userKey = "user_key";

  UserDataCache({required this.userBox, required this.userDataRepository});

  FutureVoid saveUserData(User user) async {
    await userBox.put(userKey, user);
  }

  User? getUserData() {
    return userBox.get(userKey);
  }

  FutureVoid clearUserData() async {
    await userBox.delete(userKey);
    log(userBox.keys.toString());
  }
}
