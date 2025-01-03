import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';

import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/features/auth/view/home_user_wrapper.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
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

final userDataStreamIDProvider =
    StreamProvider.family<User?, String>((ref, id) {
  return ref.watch(userDataRepoProvider).fetchUserData(id);
});

// final userDataFutureProvider = FutureProvider((ref) async {
//   return ref.watch(userDataRepoProvider).fetchUserDataFuture();
// });

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

  FutureVoid saveUserData(
    BuildContext context,
    User? user,
    File? image,
  ) async {
    state = true;
    try {
      await userDataRepo.saveUserData(user!, image!);
      log("user data saved");
      context.replace(const HomeUserDataWrapper());
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    state = false;
  }

  FutureVoid updateField(
    BuildContext context,
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    state = true;
    try {
      await userDataRepo.updateField(collection, id, data);
      log("field updated");
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    state = false;
  }
}
