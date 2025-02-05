import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/app_snackbar.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/property_listing.dart';
import '../repository/property_listing_repo.dart';

final createListingProvider = FutureProvider.family<void,
    ({BuildContext context, PropertyListing listing})>((ref, args) async {
  try {
    await ref.read(propertyListingRepoProvider).createListing(args.listing);
    showSnackBar("Property listed successfully", args.context);
    args.context.pop();
  } catch (e) {
    showSnackBar(e.toString(), args.context, isError: true);
  }
});

final updateListingProvider = FutureProvider.family<
    void,
    ({
      PropertyListing listing,
      List<String> existingImages,
      BuildContext context
    })>((ref, args) async {
 
  try {
    await ref
        .read(propertyListingRepoProvider)
        .updateListing(args.listing, args.existingImages);
    showSnackBar("Property updated successfully", args.context);
  } catch (e) {
    log(e.toString());
    showSnackBar(e.toString(), args.context, isError: true);
  }
});

final deleteListingProvider =
    FutureProvider.family<void, String?>((ref, id) async {
  await ref.read(propertyListingRepoProvider).deleteListing(id);
});

final fetchListingsProvider =
    StreamProvider.autoDispose<List<PropertyListing>?>((ref) {
  return ref.read(propertyListingRepoProvider).fetchListings();
});

final fetchListingsByAgentIDProvider =
    StreamProvider.family<List<PropertyListing>, String>((ref, agentID) {
  return ref.read(propertyListingRepoProvider).fetchListingsByAgentID(agentID);
});

final fetchListingsWithFiltersProvider =
    FutureProvider.family<List<PropertyListing>, PropertyFilter>(
        (ref, filter) async {
  await Future.delayed(const Duration(seconds: 1));
  return await ref
      .read(propertyListingRepoProvider)
      .fetchListingsWithFilters(filter);
});

final updateListingStatusProvider =
    FutureProvider.family<void, (PropertyListing, AgentModel)>(
        (ref, args) async {
  await ref
      .read(propertyListingRepoProvider)
      .updateListingStatus(args.$1, args.$2);
});
