

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';

import '../../../../../core/providers.dart';

final addToFavsProvider = FutureProvider.family<void,
    ({BuildContext? ctx, String? id, ClientModel? user})>(
  (ref, args) async {
    final userDataNot = ref.watch(userRemoteDataProvider.notifier);
    final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
    await userDataNot.updateField(
        args.ctx!,
        'clients',
        uid,
        args.user!.copyWith(
          bookmarks: [...args.user!.bookmarks, args.id!],
        ).toJson());
  },
);

final removeFavsProvider = FutureProvider.family<void,
    ({BuildContext? ctx, String? id, ClientModel? user})>(
  (ref, args) async {
    final userDataNot = ref.watch(userRemoteDataProvider.notifier);
    final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
    await userDataNot.updateField(
        args.ctx!,
        'clients',
        uid,
        args.user!.copyWith(
          bookmarks: args.user!.bookmarks.where((id) => id != args.id).toList(),
        ).toJson());
  },
);
