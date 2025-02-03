import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/app_snackbar.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';
import '../../auth/view/home_user_wrapper.dart';

final userDataNotifierProvider =
    NotifierProvider<UserDataNotifier, User?>(UserDataNotifier.new);

final userRemoteDataProvider =
    StateNotifierProvider<UserRemoteDataNotifier, Status>((ref) {
  return UserRemoteDataNotifier(ref.watch(userDataRepoProvider), ref);
});

final userDataExistsCtrl = FutureProvider((ref) async {
  final userDataRepo = ref.watch(userDataRepoProvider);
  log(ref.watch(userDataRepoProvider).toString());
  log("${await userDataRepo.userDataExists()} from ctrl");
  return await userDataRepo.userDataExists();
});

final userDataStreamProvider = StreamProvider<User?>((ref) {
  return ref
      .watch(userDataRepoProvider)
      .fetchUserData(FirebaseAuth.instance.currentUser!.uid);
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

class UserRemoteDataNotifier extends StateNotifier<Status> {
  final UserDataRepository userDataRepo;
  final Ref ref;
  UserRemoteDataNotifier(this.userDataRepo, this.ref) : super(Status.initial);

  FutureVoid saveUserData(
    BuildContext context,
    User? user,
    File? image,
  ) async {
    state = Status.loading;
    try {
      await userDataRepo.saveUserData(user!, image!);
      context.replace(HomeUserDataWrapper());
      log("user data saved");
      state = Status.success;
    } catch (e) {
      state = Status.error;
      showSnackBar(e.toString(), context);
    }
  }

  FutureVoid updateField(
    BuildContext context,
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    state = Status.loading;
    try {
      await userDataRepo.updateField(collection, id, data);
      log("field updated");
      state = Status.success;
    } catch (e) {
      showSnackBar(e.toString(), context);
      state = Status.error;
    }
  }
}
