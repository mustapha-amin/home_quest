import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/features/auth/repository/auth_repository.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';

import '../../btm_nav_bar/nav_bar_items/home/home.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authService: ref.watch(authRepoProvider), ref: ref);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository authService;
  final Ref ref;

  AuthController({
    required this.authService,
    required this.ref,
  }) : super(false);

  FutureVoid _handleOperation(FutureVoid Function() operation, Ref ref) async {
    state = true;
    ref.read(isLoading.notifier).state = state;
    await operation();
    state = false;
    ref.invalidate(isLoading);
  }

  FutureVoid signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    Either<String, UserCredential>? result;
    _handleOperation(
      () async {
        result = await authService.signIn(email: email, password: password);
      },
      ref,
    );
    result!.fold(
      (l) => showErrorDialog(context, l),
      (r) => context.replace(const HomeScreen()),
    );
  }

  FutureVoid signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    Either<String, UserCredential>? result;
    _handleOperation(
      () async {
        result = await authService.signUp(email: email, password: password);
      },
      ref,
    );
    result!.fold(
      (l) => showErrorDialog(context, l),
      (r) => context.replace(const UserTypeScreen()),
    );
  }

  FutureVoid signOut(BuildContext context) async {
    Either<String, String>? result;
    _handleOperation(() async {
      result = await authService.signOut();
    }, ref);
    result!.fold(
      (l) => showErrorDialog(context, l),
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false),
    );
  }

  FutureVoid requestPwdReset({
    required BuildContext context,
    required String email,
    required VoidCallback operation,
  }) async {
    final result = await authService.requestPaswordReset(email);
    result.fold(
      (l) => showErrorDialog(context, l),
      (r) => operation(),
    );
  }
}
