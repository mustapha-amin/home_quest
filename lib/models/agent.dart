class Agent {
  final int id, phoneNumber;
  final String name, profilePicture, email;
  List<String> listingsIDs;
  double rating;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.listingsIDs,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'listingsIDs': listingsIDs,
      'rating': rating,
    };
  }

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      listingsIDs: List<String>.from(json['listingsIDs']),
      rating: json['rating'].toDouble(),
    );
  }
}