import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/features/auth/repository/auth_repository.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';

import '../../home/views/home.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authService: ref.watch(authServiceProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthService authService;

  AuthController({
    required this.authService,
  }) : super(false);

  FutureVoid signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final result = await authService.signIn(email: email, password: password);
    state = false;
    result.fold(
      (l) => showErrorDialog(context, l),
      (r) => context.replace(const Home()),
    );
  }

  FutureVoid signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final result = await authService.signUp(email: email, password: password);
    result.fold(
      (l) => showErrorDialog(context, l),
      (r) => context.replace(const Home()),
    );
  }

  FutureVoid signOut(BuildContext context) async {
    state = true;
    final result = await authService.signOut();
    state = false;
    result.fold(
      (l) => showErrorDialog(context, l),
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false),
    );
  }
}
