class Client {
  final int phoneNumber;
  final String userID, name, email;
  final String profilePicture;
  final List<String> bookmarks;

  Client({
    required this.userID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.bookmarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'bookmarks': bookmarks,
    };
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      userID: json['userID'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      bookmarks: List<String>.from(json['bookmarks']),
    );
  }
}
