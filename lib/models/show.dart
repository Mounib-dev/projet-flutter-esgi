class TVShow {
  final String id;
  final String name;
  final String image;
  final String description;

  TVShow({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'].toString(),
      name: json['name'] ?? 'No Title',
      image: json['image_thumbnail_path'] ?? '',
      description: json['description'] ?? 'No Description',
    );
  }
}
