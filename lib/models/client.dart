// ignore_for_file: annotate_overrides, overridden_fields
import 'user.dart';

class ClientModel extends User {
  final int phoneNumber;

  final String clientID;

  final String name;

  final String profilePicture;

  final List<String> bookmarks;

  final String email;

  ClientModel({
    required this.clientID,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.bookmarks,
    required this.email,
  }) : super(
          id: clientID,
          name: name,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
          email: email,
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
      email: "email",
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
      'email': email,
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientID: json['clientID'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      bookmarks: List<String>.from(json['bookmarks']),
      email: json['email'],
    );
  }

  ClientModel copyWith({
    int? phoneNumber,
    String? clientID,
    String? name,
    String? profilePicture,
    List<String>? bookmarks,
    List<String>? appointmentIDs,
    String? email,
  }) {
    return ClientModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clientID: clientID ?? this.clientID,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      bookmarks: bookmarks ?? this.bookmarks,
      email: email ?? this.email,
    );
  }
}
