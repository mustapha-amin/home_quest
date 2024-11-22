class Agent {
  final int phoneNumber;
  final String agentID, name, profilePicture, email;
  List<String> listingsIDs;
  double rating;

  Agent({
    required this.agentID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.listingsIDs,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'agentID': agentID,
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
      agentID: json['agentID'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      listingsIDs: List<String>.from(json['listingsIDs']),
      rating: json['rating'].toDouble(),
    );
  }
}