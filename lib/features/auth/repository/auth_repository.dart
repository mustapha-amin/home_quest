import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_quest/core/providers.dart';

import '../../../core/typedefs.dart';

final authRepoProvider = Provider((ref) {
  return AuthRepository(firebaseAuth: ref.watch(firebaseAuthProvider));
});

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  AuthRepository({required this.firebaseAuth});

  Stream<User?> get onAuthStateChange => firebaseAuth.authStateChanges();

  FutureEither<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCred);
    }
      on FirebaseAuthException catch (e, _) {
      String? error;
      if (e.code == 'user-not-found') {
        error = "User not found";
      } else if (e.code == "wrong-password") {
        error = "Incorrect password";
      } else if (e.code == "network-request-failed") {
        error = "A network error occured, check your internet settings";
      } else {
        error = e.message;
      }
      return left(error!);
    }
    }
  

  FutureEither<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCredential);
    }  on FirebaseAuthException catch (e, _) {
      String? error;
      if (e.code == 'email-already-in-use') {
        error = "email already in use";
      } else if (e.code == "network-request-failed") {
        error = "A network occured, check your internet settings";
      } else {
        error = e.message.toString();
      }
      return left(error);
    }
  }

  FutureEither<String> signOut() async {
    try {
      await firebaseAuth.signOut();
      return right("success");
    } on FirebaseAuthException catch (e, _) {
      return left(e.message!);
    }
  }

  FutureEither<String> requestPaswordReset(String? email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email!);
      return right("success");
    } on FirebaseAuthException catch (e) {
      return left(e.message!);
    }
  }
}
