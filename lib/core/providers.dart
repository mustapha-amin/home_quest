import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/typedefs.dart';
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

final isLoading = StateProvider<bool>((ref) {
  return false;
});

final userCacheNotifierProvider =
    NotifierProvider<UserCacheNotifier, k.User?>(() => UserCacheNotifier());

class UserCacheNotifier extends Notifier<k.User?> {
  late final UserDataCache userDataCache;

  @override
  k.User? build() {
    userDataCache = ref.watch(userDataCacheProvider);
    return userDataCache.getUserData();
  }

  void saveData(k.User user) async {
    await userDataCache.saveUserData(user);
    state = userDataCache.getUserData();
  }

  FutureVoid deleteData() async {
    await userDataCache.clearUserData();
  }
}
