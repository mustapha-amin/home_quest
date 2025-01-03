enum ListingType { rent, sale }

enum UserType { agent, client, none }

enum PropertyType {
  apartment,
  mansion,
  bungalow,
  duplex,
}

enum Furnishing {
  unfurnished,
  semi_furnished,
  furnished,
}

enum Condition {
  old('old'),
  newly_built('Newly built'),
  renovated('Renovated');

  final String name;

  const Condition(this.name);
}

enum PropertySubtype {
  detached('detached'),
  semi_detached('semi detached');

  final String name;

  const PropertySubtype(this.name);
}

enum Facility {
  prepaid_meter("Prepaid meter"),
  pop_ceiling("POP ceiling"),
  tiled_floor("Tiled floor"),
  wardrobe('Wardrobe'),
  balcony('Balcony'),
  running_water('Running water'),
  parking_space('Parking space'),
  electricity("Electricity");

  final String name;

  const Facility(this.name);
}

enum Feature {
  bedrooms("Bedrooms"),
  bathrooms("Bathrooms"),
  kitchens("Kitchens"),
  sitting_rooms("Sitting rooms");

  final String name;

  const Feature(this.name);
}
