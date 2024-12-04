import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/features/auth/view/home_user_wrapper.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';

import '../../../core/providers.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';

final userDataNotifierProvider =
    NotifierProvider<UserDataNotifier, User?>(UserDataNotifier.new);

final userRemoteDataProvider =
    StateNotifierProvider<UserRemoteDataNotifier, bool>((ref) {
  return UserRemoteDataNotifier(ref.watch(userDataRepoProvider), ref);
});

final userDataExistsProvider = FutureProvider((ref) async {
  return await ref.watch(userDataRepoProvider).userDataExists();
});

final userDataStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(userDataRepoProvider).fetchUserData();
});

class UserDataNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void updateUserData(User user) {
    state = user;
  }
}

class UserRemoteDataNotifier extends StateNotifier<bool> {
  final UserDataRepository userDataRepo;
  final Ref ref;
  UserRemoteDataNotifier(this.userDataRepo, this.ref) : super(false);

  FutureVoid _handleOperation(FutureVoid Function() operation, Ref ref) async {
    state = true;
    ref.read(isLoading.notifier).state = state;
    await operation();
    state = false;
    ref.invalidate(isLoading);
  }

  FutureVoid saveUserData(BuildContext context, User? user, File image) async {
    try {
      await _handleOperation(() async {
        await userDataRepo.saveUserData(user!, image);
        context.replace(const HomeUserDataWrapper());
      }, ref);
    } catch (e) {
      ref.invalidate(isLoading);
      showErrorDialog(context, e.toString());
    }
  }
}
