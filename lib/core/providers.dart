import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
import 'package:home_quest/services/user_data_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as k;

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final appWriteClientProvider = Provider((ref) {
  final client = Client()
      .setProject("6743d7ff003cffb7cfd5")
      .setEndpoint("https://cloud.appwrite.io/v1");
  return client;
});

final appwriteStorageProvider = Provider((ref) {
  final storage = Storage(ref.watch(appWriteClientProvider));

  return storage;
});

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final authChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});


final userCacheNotifierProvider =
    NotifierProvider<UserCacheNotifier, k.User?>(() => UserCacheNotifier());

final hiveProvider = Provider((ref) => Hive.box<k.User>("userBox"));

class UserCacheNotifier extends Notifier<k.User?> {
  late final UserDataCache userDataCache;

  @override
  k.User? build() {
    userDataCache = ref.watch(userDataCacheProvider);
    return userDataCache.getUserData();
  }

  FutureVoid deleteData() async {
    await userDataCache.clearUserData();
    log("Deleted");
  }

  FutureVoid refreshFromServer() async {
    try {
      final user = await ref.read(userDataRepoProvider).fetchUserDataFuture();
      await userDataCache.saveUserData(user!);
      state = userDataCache.getUserData();
      log("Cache updated");
    } catch (e) {
      log("Cache failed to update");
      throw Exception(e.toString());
    }
  }
}
