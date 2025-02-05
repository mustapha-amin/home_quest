class GeoLocation {
  String? city, county, state;
  double? lat, lng;

  GeoLocation({this.city, this.county, this.state, this.lat, this.lng});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      city: json['address']['city'] ??  json['address']['county'] ?? json['address']['state'],
      county: json['address']['county'] ?? json['address']['city'] ?? json['address']['state'],
      state: json['address']['state'],
      lat: double.parse(json['lat']),
      lng: double.parse(json['lon']),
    );
  }

  @override
  String toString() {
    return """
  City: '$city\n
  County: '$county\n
  State: '$state\n
  Latlong: '$lat + $lng\n
""";
  }
}
