class ContentModel {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> genres;
  final String type; // مانهوا، مانگا، و...
  final String lastChapter;
  final double rating;
  final int reviewsCount;
  final String summary;
  final String pricePerChapter;

  ContentModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.genres,
    required this.type,
    required this.lastChapter,
    required this.rating,
    required this.reviewsCount,
    required this.summary,
    required this.pricePerChapter,
  });
}
