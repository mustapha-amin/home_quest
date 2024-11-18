class ListingFeature {
  final String feature;
  final int? number;

  ListingFeature({
    required this.feature,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      'feature': feature,
      'number': number,
    };
  }

  factory ListingFeature.fromJson(Map<String, dynamic> json) {
    return ListingFeature(
      feature: json['feature'],
      number: json['number'],
    );
  }
}
