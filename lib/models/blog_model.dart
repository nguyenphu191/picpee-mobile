class BlogModel {
  final String id;
  final String imageUrl;
  final String author;
  final String title;
  final String category;
  final DateTime publishDate;
  BlogModel({
    this.id = "",
    required this.author,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.publishDate,
  });
}
