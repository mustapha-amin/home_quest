class Review {
  final String userID, reviewID, text;
  final int rating;

  Review(
      {required this.userID,
      required this.reviewID,
      required this.text,
      required this.rating});

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'reviewID': reviewID,
      'text': text,
      'rating': rating,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userID: json['userID'],
      text: json['text'],
      reviewID: json['reviewID'],
      rating: json['rating'],
    );
  }
}
