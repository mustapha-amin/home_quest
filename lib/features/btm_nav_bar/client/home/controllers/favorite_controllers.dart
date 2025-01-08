import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/utils/app_snackbar.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/repository/property_listing_repo.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
import 'package:home_quest/main.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/providers.dart';
import '../../../../../core/utils/textstyle.dart';

void displaySnackbar(PropertyListing propertyListing, bool added) {
  try {
    scaffoldKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 700),
        elevation: 2,
        padding: const EdgeInsets.all(6),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        content: Row(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    propertyListing.imagesUrls[0],
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Text(
              "${added ? 'Added to' : 'Removed from'} bookmarks",
              style: kTextStyle(16),
            )
          ],
        ),
      ));
  } on Exception catch (e) {
    log(e.toString());
  }
}

final fetchFavsProvider =
    FutureProvider.family<List<PropertyListing>, List<String>>(
        (ref, ids) async {
  return ref.watch(propertyListingRepoProvider).fetchListingsByIDs(ids);
});

final updateBookmarksProv = FutureProvider.family<
    void,
    ({
      PropertyListing listing,
      List<String> bookmarks,
      String id,
      bool isAddition
    })>(
  (ref, args) async {
    try {
      final userDataRepo = ref.watch(userDataRepoProvider);
      await userDataRepo.updateBookmarks(args.isAddition
          ? [...args.bookmarks, args.id]
          : args.bookmarks.where((bkmrk) => bkmrk != args.id).toList());
      displaySnackbar(args.listing, args.isAddition);
      log("${args.isAddition ? '' : 'Un'}bookmarked");
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      showSnackBar("An error occured");
    }
  },
);
