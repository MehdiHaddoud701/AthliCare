class VitaminModel {
  final int vitaminId;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String fullDescription;
  final List<String> benefits;
  final String dosage;
  final List<String> sources;
  final DateTime createdAt;

  VitaminModel({
    required this.vitaminId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.fullDescription,
    required this.benefits,
    required this.dosage,
    required this.sources,
    required this.createdAt,
  });

  factory VitaminModel.fromMap(Map<String, dynamic> map) {
    return VitaminModel(
      vitaminId: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'Vitamins',
      fullDescription: map['fullDescription'] ?? '',
      benefits: List<String>.from(map['benefits'] ?? []),
      dosage: map['dosage'] ?? '',
      sources: List<String>.from(map['sources'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': vitaminId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'fullDescription': fullDescription,
      'benefits': benefits,
      'dosage': dosage,
      'sources': sources,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
