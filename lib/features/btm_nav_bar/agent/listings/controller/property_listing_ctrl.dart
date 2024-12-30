import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/models/property_listing.dart';

import '../repository/property_listing_repo.dart';

final createListingProvider = FutureProvider.family<void, PropertyListing>((ref, propertyListing) async {
  await ref.read(propertyListingRepoProvider).createListing(propertyListing);
});

final updateListingProvider = FutureProvider.family<void, PropertyListing>((ref, propertyListing) async {
  await ref.read(propertyListingRepoProvider).updateListing(propertyListing);
});

final deleteListingProvider = FutureProvider.family<void, String?>((ref, id) async {
  await ref.read(propertyListingRepoProvider).deleteListing(id);
});

final fetchListingsProvider = FutureProvider.autoDispose<List<PropertyListing>>((ref) async {
  return await ref.read(propertyListingRepoProvider).fetchListings();
});

final fetchListingsByAgentIDProvider = FutureProvider.family<List<PropertyListing>, String>((ref, agentID) async {
  return await ref.read(propertyListingRepoProvider).fetchListingsByAgentID(agentID);
});

final fetchListingsWithFiltersProvider = FutureProvider.family<List<PropertyListing>, PropertyFilter>((ref, filter) async {
  return await ref.read(propertyListingRepoProvider).fetchListingsWithFilters(filter);
});