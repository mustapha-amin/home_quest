import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, PropertyFilter>((ref) {
  return SearchFilterNotifier();
});

PropertyFilter defaultState = (
  bathrooms: 1,
  bedrooms: 0,
  condition: Condition.all,
  minPrice: 0,
  maxPrice: 0,
  state: null,
  lga: null,
  listingType: ListingType.rent,
  propertyType: PropertyType.all,
  propertySubtype: PropertySubtype.all,
  minPropertySize: 0,
  maxPropertySize: 0,
  kitchens: 1,
  sittingRooms: 0
);

class SearchFilterNotifier extends StateNotifier<PropertyFilter> {
  SearchFilterNotifier() : super(defaultState);

  void updateFilter(PropertyFilter propertyFilter) {
    state = propertyFilter;
  }
}
