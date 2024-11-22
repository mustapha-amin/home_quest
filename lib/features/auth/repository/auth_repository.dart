import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_quest/core/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/typedefs.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(supabaseClient: ref.watch(supabaseClientProvider));
});

class AuthService {
  final SupabaseClient supabaseClient;
  AuthService({required this.supabaseClient});

  Stream<AuthState> get onAuthStateChange => supabaseClient.auth.onAuthStateChange;

  FutureEither<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return right(authResponse);
    } on AuthApiException catch (e, _) {
      return left(e.message);
    }
  }

  FutureEither<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      return right(userCredential);
    } on AuthApiException catch (e, _) {
      return left(e.message);
    }
  }

  FutureEither<String> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      return right("success");
    } on AuthApiException catch (e, _) {
      return left(e.message);
    }
  }
}
