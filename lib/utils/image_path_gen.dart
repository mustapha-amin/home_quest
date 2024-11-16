enum ImageType { png, jpg, gif }

String genImagePath(String? name, ImageType type) {
  return switch (type) {
    ImageType.png => "assets/images/$name.png",
    ImageType.jpg => "assets/images/$name.jpg",
    _ => "assets/images/$name.gif"
  };
}
