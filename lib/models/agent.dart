class AgentModel {
  final int phoneNumber;
  final String agentID, name, profilePicture;
  final List<String> listingsIDs;
  final double rating;

  AgentModel({
    required this.agentID,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.listingsIDs,
    required this.rating,
  });

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
    );
  }

  AgentModel copyWith({
    int? phoneNumber,
    String? agentID,
    String? name,
    String? profilePicture,
    List<String>? listingsIDs,
    double? rating,
  }) {
    return AgentModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      agentID: agentID ?? this.agentID,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      listingsIDs: listingsIDs ?? this.listingsIDs,
      rating: rating ?? this.rating,
    );
  }
}
