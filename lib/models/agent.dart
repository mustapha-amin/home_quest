// ignore_for_file: annotate_overrides, overridden_fields

import 'package:home_quest/models/review.dart';

import 'user.dart';

class AgentModel extends User {
  final int phoneNumber;

  final String agentID;

  final String name;

  final String profilePicture;

  final List<String> listingsIDs;

  final double rating;

  final List<Review> reviews;

  AgentModel({
    required this.agentID,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.listingsIDs,
    required this.rating,
    required this.reviews,
  }) : super(
          id: agentID,
          name: name,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
        );

  @override
  String toString() {
    return "$phoneNumber $agentID $name $rating";
  }

  factory AgentModel.defaultInstance() {
    return AgentModel(
      agentID: "agentID",
      name: 'name',
      phoneNumber: 123,
      profilePicture: "profilePicture",
      listingsIDs: [],
      rating: 0,
      reviews: [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'agentID': agentID,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'listingsIDs': listingsIDs,
      'rating': rating,
      'reviews' : reviews,
    };
  }

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      agentID: json['agentID'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      listingsIDs: List<String>.from(json['listingsIDs']),
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List<dynamic>).map((review) => Review.fromJson(review)).toList(),
    );
  }

  AgentModel copyWith({
    int? phoneNumber,
    String? agentID,
    String? name,
    String? profilePicture,
    List<String>? listingsIDs,
    double? rating,
    List<Review>? reviews
  }) {
    return AgentModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      agentID: agentID ?? this.agentID,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      listingsIDs: listingsIDs ?? this.listingsIDs,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews
    );
  }
}
