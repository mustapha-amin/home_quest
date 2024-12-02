import 'package:home_quest/models/listing_feature.dart';

import '../core/enums.dart';

class PropertyListing {
  final String id, agentID, address;
  final double price, agentFee, propertySize;
  final ListingType listingType;
  final PropertyType propertyType;
  final List<String> imagesUrls;
  final Furnishing furnishing;
  final Condition condition;
  final PropertySubtype propertySubtype;
  final List<ListingFeature> features;
  final List<Facility> facilities;

  PropertyListing({
    required this.id,
    required this.agentID,
    required this.address,
    required this.propertyType,
    required this.propertySize,
    required this.price,
    required this.agentFee,
    required this.listingType,
    required this.imagesUrls,
    required this.features,
    required this.condition,
    required this.facilities,
    required this.furnishing,
    required this.propertySubtype,
  });

  @override
  String toString() {
    return "$id $agentID $address $propertyType $propertySize $price $agentFee $listingType $imagesUrls $features $condition $facilities $furnishing $propertySubtype";
  }

  // Convert PropertyListing to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agentID': agentID,
      'address': address,
      'propertyType': propertyType.name,
      'propertySize': propertySize,
      'price': price,
      'agentFee': agentFee,
      'listingType': listingType.name,
      'imagesUrls': imagesUrls,
      'features': features.map((feature) => feature.toJson()).toList(),
      'condition': condition.name,
      'facilities': facilities.map((facility) => facility).toList(),
      'furnishing': furnishing.name,
      'propertySubtype': propertySubtype.name,
    };
  }

  // Create PropertyListing from JSON
  factory PropertyListing.fromJson(Map<String, dynamic> json) {
    return PropertyListing(
      id: json['id'],
      agentID: json['agentID'],
      address: json['address'],
      propertyType: PropertyType.values.byName(json['propertyType']),
      propertySize: json['propertySize'].toDouble(),
      price: json['price'].toDouble(),
      agentFee: json['agentFee'].toDouble(),
      listingType: ListingType.values.byName(json['listingType']),
      imagesUrls: List<String>.from(json['imagesUrls']),
      features: (json['features'] as List)
          .map((feature) => ListingFeature.fromJson(feature))
          .toList(),
      condition: Condition.values.byName(json['condition']),
      facilities: (json['facilities'] as List<String>)
          .map((facility) => Facility.values.byName(facility))
          .toList(),
      furnishing: Furnishing.values.byName(json['furnishing']),
      propertySubtype: PropertySubtype.values.byName(json['propertySubtype']),
    );
  }
}
