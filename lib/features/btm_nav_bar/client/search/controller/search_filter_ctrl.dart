import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/typedefs.dart';

import '../../../../../models/property_listing.dart';
import '../../../agent/listings/repository/property_listing_repo.dart';

final searchListingProvider =
    FutureProvider.family<List<PropertyListing>, PropertyFilter>(
        (ref, filter) async {
  return await ref
      .watch(propertyListingRepoProvider)
      .fetchListingsWithFilters(filter);
});

final searchFilterProvider = StateNotifierProvider<SearchFilterNotifier,
    ({PropertyFilter filter, bool searching})>((ref) {
  return SearchFilterNotifier();
});

PropertyFilter defaultFilter = (
  bathrooms: 0,
  bedrooms: 0,
  condition: Condition.all,
  minPrice: 0,
  maxPrice: 999999999,
  state: null,
  lga: null,
  listingType: ListingType.rent,
  propertyType: PropertyType.all,
  propertySubtype: PropertySubtype.all,
  minPropertySize: 0,
  maxPropertySize: 99999999,
  kitchens: 0,
  sittingRooms: 0
);

class SearchFilterNotifier
    extends StateNotifier<({PropertyFilter filter, bool searching})> {
  SearchFilterNotifier() : super((filter: defaultFilter, searching: false));

  void updateFilter(PropertyFilter propertyFilter, {bool searching = false}) {
    state = (filter: propertyFilter, searching: searching);
  }
}
