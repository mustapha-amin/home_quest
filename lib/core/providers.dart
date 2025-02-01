import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final isLoadingProvider = StateProvider((ref) {
  return false;
});

final globalLoadingProvider =
    StateNotifierProvider<GloabalLoadingNotifier, bool>((ref) {
  return GloabalLoadingNotifier();
});

class GloabalLoadingNotifier extends StateNotifier<bool> {
  GloabalLoadingNotifier() : super(false);

  void toggleGlobalLoadingIndicator(bool isLoading) {
    state = isLoading;
  }
}

