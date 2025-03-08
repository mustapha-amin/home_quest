abstract class User {
  final String id, name, profilePicture, email;
  final int phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.phoneNumber,
    required this.email,
  });

  User? copyWith();

  Map<String, dynamic> toJson();
}
