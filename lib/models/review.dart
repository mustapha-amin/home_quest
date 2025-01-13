class Review {
  final String userID, reviewID, text;

  Review({required this.userID, required this.reviewID, required this.text});

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'reviewID': reviewID,
      'text': text,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userID: json['userID'],
      text: json['text'],
      reviewID: json['reviewID'],
    );
  }
}
