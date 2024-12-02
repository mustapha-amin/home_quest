import 'package:home_quest/core/enums.dart';

class ListingFeature {
  final Feature feature;
  final int number;

  ListingFeature({
    required this.feature,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      'feature': feature.name,
      'number': number,
    };
  }

  factory ListingFeature.fromJson(Map<String, dynamic> json) {
    return ListingFeature(
      feature: Feature.values.byName(json['feature']),
      number: json['number'],
    );
  }
}
