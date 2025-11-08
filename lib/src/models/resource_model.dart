class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String category;

  ResourceModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.url,
    this.category = 'General',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'url': url,
    'category': category,
  };

  factory ResourceModel.fromMap(Map<String, dynamic> m) => ResourceModel(
    id: m['id'] ?? '',
    title: m['title'] ?? '',
    description: m['description'] ?? '',
    url: m['url'] ?? '',
    category: m['category'] ?? 'General',
  );
}
