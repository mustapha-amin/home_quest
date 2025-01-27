import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/enums.dart';

class PropertyListing {
  final String id, agentID, address, state, lga;
  final double price, agentFee, propertySize;
  final int bedrooms, kitchens, bathrooms, sittingRooms;
  final ListingType listingType;
  final PropertyType propertyType;
  final List<String> imagesUrls;
  final Furnishing furnishing;
  final Condition condition;
  final PropertySubtype propertySubtype;
  final List<Facility> facilities;
  final GeoPoint geoPoint;

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
    required this.bedrooms,
    required this.kitchens,
    required this.bathrooms,
    required this.sittingRooms,
    required this.condition,
    required this.facilities,
    required this.furnishing,
    required this.propertySubtype,
    required this.geoPoint,
    required this.state,
    required this.lga,
  });

  @override
  String toString() {
    return "$id $agentID $address $propertyType $propertySize $state $lga $price $agentFee $listingType $imagesUrls"
        "$bedrooms $kitchens $bathrooms $sittingRooms $condition $facilities $furnishing $propertySubtype ${geoPoint.toString()} $price $agentFee";
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
      'bedrooms': bedrooms,
      'sittingRooms': sittingRooms,
      'kitchens': kitchens,
      'bathrooms': bathrooms,
      'condition': condition.name,
      'facilities': facilities.map((facility) => facility.name).toList(),
      'furnishing': furnishing.name,
      'propertySubtype': propertySubtype.name,
      'geoPoint': geoPoint,
      'state': state,
      'lga': lga,
    };
  }

  // Create PropertyListing from JSON
  factory PropertyListing.fromJson(Map<String, dynamic> json) {
    return PropertyListing(
      id: json['id'],
      agentID: json['agentID'],
      address: json['address'],
      propertyType: PropertyType.values
          .byName(json['propertyType']), // Convert string to enum
      propertySize: json['propertySize'].toDouble(),
      price: json['price'].toDouble(),
      agentFee: json['agentFee'].toDouble(),
      listingType: ListingType.values
          .byName(json['listingType']), // Convert string to enum
      imagesUrls: List<String>.from(json['imagesUrls']),
      bedrooms: json['bedrooms'],
      sittingRooms: json['sittingRooms'],
      bathrooms: json['bathrooms'],
      kitchens: json['kitchens'],
      condition: Condition.values.firstWhere(
        (condition) => condition.name == json['condition'],
        orElse: () => Condition.all,
      ),
      facilities: (json['facilities'] as List)
          .map((facilityString) => Facility.values.firstWhere(
                (facility) => facility.name == facilityString,
                orElse: () => Facility.electricity,
              ))
          .toList(),
      furnishing: Furnishing.values.firstWhere(
        (furnishing) => furnishing.name == json['furnishing'],
        orElse: () => Furnishing.unfurnished,
      ),
      propertySubtype: PropertySubtype.values.firstWhere(
        (subtype) => subtype.name == json['propertySubtype'],
        orElse: () => PropertySubtype.all,
      ),
      geoPoint: json['geoPoint'],
      state: json['state'],
      lga: json['lga'],
    );
  }

  PropertyListing copyWith({
    String? id,
    String? agentID,
    String? address,
    double? price,
    double? agentFee,
    double? propertySize,
    ListingType? listingType,
    PropertyType? propertyType,
    List<String>? imagesUrls,
    Furnishing? furnishing,
    Condition? condition,
    PropertySubtype? propertySubtype,
    List<Facility>? facilities,
    int? bedrooms,
    int? bathrooms,
    int? kitchens,
    int? sittingRooms,
    GeoPoint? geoPoint,
    String? state,
    String? lga,
  }) {
    return PropertyListing(
      id: id ?? this.id,
      agentID: agentID ?? this.agentID,
      address: address ?? this.address,
      price: price ?? this.price,
      agentFee: agentFee ?? this.agentFee,
      propertySize: propertySize ?? this.propertySize,
      listingType: listingType ?? this.listingType,
      propertyType: propertyType ?? this.propertyType,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      furnishing: furnishing ?? this.furnishing,
      condition: condition ?? this.condition,
      propertySubtype: propertySubtype ?? this.propertySubtype,
      bathrooms: bathrooms ?? this.bathrooms,
      kitchens: kitchens ?? this.kitchens,
      sittingRooms: sittingRooms ?? this.sittingRooms,
      bedrooms: bedrooms ?? this.bedrooms,
      facilities: facilities ?? this.facilities,
      geoPoint: geoPoint ?? this.geoPoint,
      state: state ?? this.state,
      lga: lga ?? this.lga,
    );
  }
}
