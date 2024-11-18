import 'package:home_quest/models/listing_feature.dart';

import '../core/enums.dart';

class PropertyListing {
  final String id, agentID, address, description;
  final double price, agentFee, propertySize;
  final ListingType listingType;
  final List<String> images;
  List<ListingFeature> features;

  PropertyListing({
    required this.id,
    required this.agentID,
    required this.address,
    required this.description,
    required this.propertySize,
    required this.price,
    required this.agentFee,
    required this.listingType,
    required this.images,
    required this.features,
  });

  // Convert PropertyListing to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agentID': agentID,
      'address': address,
      'description': description,
      'propertySize': propertySize,
      'price': price,
      'agentFee': agentFee,
      'listingType': listingType.name,
      'images': images,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }

  // Create PropertyListing from JSON
  factory PropertyListing.fromJson(Map<String, dynamic> json) {
    return PropertyListing(
      id: json['id'],
      agentID: json['agentID'],
      address: json['address'],
      description: json['description'],
      propertySize: json['propertySize'].toDouble(),
      price: json['price'].toDouble(),
      agentFee: json['agentFee'].toDouble(),
      listingType: ListingType.values
          .firstWhere((type) => type.name == json['listingType']),
      images: List<String>.from(json['images']),
      features: (json['features'] as List)
          .map((feature) => ListingFeature.fromJson(feature))
          .toList(),
    );
  }
}
