import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/typedefs.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  AuthService({required this.firebaseAuth});

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  @override
  FutureEither<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCredential);
    } on FirebaseException catch (e, _) {
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

  @override
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
    } on FirebaseAuthException catch (e, _) {
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

  @override
  FutureEither<String> signOut() async {
    try {
      await firebaseAuth.signOut();
      return right("success");
    } catch (e, _) {
      return left(e.toString());
    }
  }
}