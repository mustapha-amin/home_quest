

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/repository/property_listing_repo.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/property_listing.dart';

import '../../../../../core/providers.dart';

final addToFavsProvider = FutureProvider.family<void,
    ({BuildContext? ctx, String? id, ClientModel? user})>(
  (ref, args) async {
    final userDataNot = ref.watch(userRemoteDataProvider.notifier);
    final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
    final user =  args.user!.copyWith(bookmarks: [...args.user!.bookmarks, args.id!]);
    await userDataNot.updateField(
        args.ctx!,
        'clients',
        uid,
       user.toJson());
  },
);

final removeFavsProvider = FutureProvider.family<void,
    ({BuildContext? ctx, String? id, ClientModel? user})>(
  (ref, args) async {
    final userDataNot = ref.watch(userRemoteDataProvider.notifier);
    final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
    final user = args.user!.copyWith(
          bookmarks: args.user!.bookmarks.where((id) => id != args.id).toList()
        );
    await userDataNot.updateField(
        args.ctx!,
        'clients',
        user.,
        user.toJson());
  },
);

final fetchFavsProvider = FutureProvider.family<List<PropertyListing>, List<String>>((ref, ids) async {
  return await ref.watch(propertyListingRepoProvider).fetchListingsByIDs(ids);
});
