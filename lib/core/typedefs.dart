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
  int? bathrooms,
  int? kitchens,
  int? sittingRooms,
});

extension PropertyFilterExts on PropertyFilter {
  PropertyFilter copyWith({
    double? minPrice,
    double? maxPrice,
    String? state,
    String? lga,
    ListingType? listingType,
    Condition? condition,
    PropertyType? propertyType,
    PropertySubtype? propertySubtype,
    double? minPropertySize,
    double? maxPropertySize,
    int? bedrooms,
    int? bathrooms,
    int? kitchens,
    int? sittingRooms,
  }) {
    return (
      bathrooms: bathrooms ?? this.bathrooms,
      bedrooms: bedrooms ?? this.bedrooms,
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      listingType: listingType ?? this.listingType,
      propertyType: propertyType ?? this.propertyType,
      propertySubtype: propertySubtype ?? this.propertySubtype,
      minPropertySize: minPropertySize ?? this.minPropertySize,
      maxPropertySize: maxPropertySize ?? this.maxPropertySize,
      kitchens: kitchens ?? this.kitchens,
      sittingRooms: sittingRooms ?? this.sittingRooms,
    );
  }
}
