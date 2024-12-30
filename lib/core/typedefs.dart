import 'package:fpdart/fpdart.dart';

import 'enums.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

typedef FutureVoid = Future<void>;


typedef PropertyFilter = ({
  double? minPrice,
  double? maxPrice,
  String? state,
  String? lga,
  ListingType? listingType,
  Condition? condition,
  PropertyType? propertyType,
  PropertySubtype? propertySubtype,
  double minPropertySize,
  double maxPropertySize,
  int? bedrooms,
  int? toilets,
  int? kitchens,
  int? sittingRooms,
});