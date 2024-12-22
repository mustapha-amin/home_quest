abstract class User {
  final String id, name, profilePicture;
  final int phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.phoneNumber,
  });

  User? copyWith();

  Map<String, dynamic> toJson();
}
