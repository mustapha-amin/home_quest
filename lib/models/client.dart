// ignore_for_file: annotate_overrides, overridden_fields
import 'package:hive_flutter/hive_flutter.dart';
import 'user.dart';

part 'client.g.dart';

@HiveType(typeId: 1)
class ClientModel extends User {
  @HiveField(0)
  final int phoneNumber;
  @HiveField(1)
  final String clientID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String profilePicture;
  @HiveField(4)
  final List<String> bookmarks;

  ClientModel({
    required this.clientID,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.bookmarks,
  }) : super(
          id: clientID,
          name: name,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
        );

  @override
  String toString() {
    return "$phoneNumber $clientID $name $profilePicture";
  }

  factory ClientModel.defaultInstance() {
    return ClientModel(
      clientID: "clientID",
      name: 'name',
      phoneNumber: 123,
      profilePicture: "profilePicture",
      bookmarks: [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'clientID': clientID,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'bookmarks': bookmarks,
    };
  }
  
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientID: json['clientID'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      bookmarks: List<String>.from(json['bookmarks']),
    );
  }
  
  ClientModel copyWith({
    int? phoneNumber,
    String? clientID,
    String? name,
    String? profilePicture,
    List<String>? bookmarks,
    List<String>? appointmentIDs,
  }) {
    return ClientModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clientID: clientID ?? this.clientID,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }
}
