class Article {
  final String title;
  final String description;
  final String author;
  final String? urlToImage;
  final String publishedAt;
  final String content;

  Article(
      {required this.title,
      required this.description,
      required this.author,
      this.urlToImage,
      required this.publishedAt,
      required this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'No Author',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? 'No Date',
      content: json['content'] ?? 'content',
    );
  }

  String get formattedDate {
    final parts = publishedAt.split('T');
    if (parts.length == 2) {
      final datePart = parts[0];
      final timePart = parts[1].split('Z')[0];
      return '$datePart at $timePart';
    }
    return publishedAt;
  }
}
