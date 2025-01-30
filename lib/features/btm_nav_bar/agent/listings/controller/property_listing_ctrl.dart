import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/models/property_listing.dart';

import '../repository/property_listing_repo.dart';

final createListingProvider =
    FutureProvider.family<void, PropertyListing>((ref, listing) async {
  await ref.read(propertyListingRepoProvider).createListing(listing);
});

final updateListingProvider = FutureProvider.family<
    void,
    ({
      PropertyListing listing,
      List<String> existingImages
    })>((ref, args) async {
  await ref
      .read(propertyListingRepoProvider)
      .updateListing(args.listing, args.existingImages);
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
