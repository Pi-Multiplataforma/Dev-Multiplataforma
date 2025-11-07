class ImageModel {
  final String url;
  final String alt;
  ImageModel({required this.url, required this.alt});

  factory ImageModel.fromJSON(Map<String, dynamic> decoded) {
    final first = (decoded['photos'] as List).cast<Map<String, dynamic>>().first;
    final src = first['src'] as Map<String, dynamic>;
    return ImageModel(
      url: src['medium'] as String,
      alt: (first['alt'] as String?) ?? '',
    );
  }
}
