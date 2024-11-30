abstract class User {
  final String id, name, profilePicture;
  final int phoneNumber;
  final List<String> appointmentIDs;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.phoneNumber,
    required this.appointmentIDs,
  });

}
