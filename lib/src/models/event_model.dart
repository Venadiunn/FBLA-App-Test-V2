class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final DateTime endsAt;
  final String location;
  final String type;

  EventModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.startsAt,
    required this.endsAt,
    this.location = '',
    this.type = 'General',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'startsAt': startsAt.toIso8601String(),
    'endsAt': endsAt.toIso8601String(),
    'location': location,
    'type': type,
  };

  factory EventModel.fromMap(Map<String, dynamic> m) => EventModel(
    id: m['id'] ?? '',
    title: m['title'] ?? '',
    description: m['description'] ?? '',
    startsAt: DateTime.parse(m['startsAt']),
    endsAt: DateTime.parse(m['endsAt']),
    location: m['location'] ?? '',
    type: m['type'] ?? 'General',
  );
}
