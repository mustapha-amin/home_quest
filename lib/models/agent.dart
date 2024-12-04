// ignore_for_file: annotate_overrides, overridden_fields
import 'package:hive_flutter/hive_flutter.dart';

import 'user.dart';

part 'agent.g.dart';

@HiveType(typeId: 0)
class AgentModel extends User {
  @HiveField(0)
  final int phoneNumber;
  @HiveField(1)
  final String agentID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String profilePicture;
  @HiveField(4)
  final List<String> listingsIDs;
  @HiveField(5)
  final List<String> appointmentIDs;
  @HiveField(6)
  final double rating;

  AgentModel({
    required this.agentID,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.listingsIDs,
    required this.rating,
    required this.appointmentIDs,
  }) : super(
          id: agentID,
          name: name,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
          appointmentIDs: appointmentIDs,
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
      appointmentIDs: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agentID': agentID,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'listingsIDs': listingsIDs,
      'rating': rating,
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
      appointmentIDs: List<String>.from(json['appointmentIDs']),
    );
  }

  AgentModel copyWith(
      {int? phoneNumber,
      String? agentID,
      String? name,
      String? profilePicture,
      List<String>? listingsIDs,
      double? rating,
      List<String>? appointmentIDs}) {
    return AgentModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      agentID: agentID ?? this.agentID,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      listingsIDs: listingsIDs ?? this.listingsIDs,
      rating: rating ?? this.rating,
      appointmentIDs: appointmentIDs ?? this.appointmentIDs,
    );
  }
}
