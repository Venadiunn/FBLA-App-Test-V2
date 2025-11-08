class PostModel {
  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final int likes;

  PostModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.likes = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'authorId': authorId,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
  };

  factory PostModel.fromMap(Map<String, dynamic> m) => PostModel(
    id: m['id'] ?? '',
    authorId: m['authorId'] ?? '',
    content: m['content'] ?? '',
    createdAt: DateTime.parse(m['createdAt']),
    likes: m['likes'] ?? 0,
  );
}
