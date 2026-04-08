class Article {
  final int articleId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String fullDescription;
  final List<String> tips;
  final DateTime createdAt;

  Article({
    required this.articleId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.fullDescription,
    required this.tips,
    required this.createdAt,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      articleId: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'Articles & Tips',
      fullDescription: map['fullDescription'] ?? '',
      tips: List<String>.from(map['tips'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': articleId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'fullDescription': fullDescription,
      'tips': tips,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
