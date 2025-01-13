import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:home_quest/core/extensions.dart';

import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/app_snackbar.dart';
import 'package:home_quest/features/auth/repository/auth_repository.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/auth/view/home_user_wrapper.dart';
import 'package:home_quest/features/btm_nav_bar/agent/btm_nav_barA.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';

import '../../../main.dart';
import '../../btm_nav_bar/client/home/views/home.dart';
import '../../user setup/controller/user_data_controller.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authService: ref.watch(authRepoProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository authService;

  AuthController({
    required this.authService,
  }) : super(false);

  FutureVoid signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    Either<String, UserCredential>? result;
    state = true;
    result = await authService.signIn(email: email, password: password);
    state = false;
    result.fold(
      (l) => showSnackBar(l),
      (r) => context.replace(const HomeUserDataWrapper()),
    );
    return null;
  }

  FutureVoid signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    Either<String, UserCredential>? result;
    state = true;
    result = await authService.signUp(email: email, password: password);
    state = false;
    result.fold(
      (l) => showSnackBar(l),
      (r) => context.replace(const UserTypeScreen()),
    );
    return null;
  }

  FutureVoid signOut(BuildContext context, WidgetRef ref, bool isClient) async {
    Either<String, String>? result;
    state = true;
    result = await authService.signOut();
    state = false;
    result.fold((l) => showSnackBar(l), (r) {
      ref.invalidate(
          isClient ? currentScreenProvider : currentAgentScreenProvider);
      ref.invalidate(authControllerProvider);
      ref.invalidate(userDataStreamProvider);
      ref.invalidate(currentScreenProvider);
      ref.invalidate(currentAgentScreenProvider);
      ref.invalidate(userDataExistsProvider);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    });
    return null;
  }

  FutureVoid requestPwdReset({
    required BuildContext context,
    required String email,
    required VoidCallback operation,
  }) async {
    final result = await authService.requestPaswordReset(email);
    result.fold(
      (l) => showSnackBar(l),
      (r) => operation(),
    );
    return null;
  }
}
