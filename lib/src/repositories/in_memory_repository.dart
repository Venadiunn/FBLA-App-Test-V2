import 'package:uuid/uuid.dart';
import 'repository.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/post_model.dart';
import '../models/resource_model.dart';

class InMemoryRepository implements Repository {
  final _uuid = const Uuid();

  final List<EventModel> _events = [];
  final List<PostModel> _posts = [];
  final List<ResourceModel> _resources = [];

  InMemoryRepository() {
    // Seed sample data
    final now = DateTime.now();
    _events.addAll([
      EventModel(
        id: _uuid.v4(),
        title: 'State Leadership Conference',
        description: 'Bring your best projects and compete!',
        startsAt: now.add(const Duration(days: 10)),
        endsAt: now.add(const Duration(days: 11)),
        location: 'State Convention Center',
        type: 'Conference',
      ),
      EventModel(
        id: _uuid.v4(),
        title: 'Chapter Meeting',
        description: 'Monthly chapter meeting.',
        startsAt: now.add(const Duration(days: 3)),
        endsAt: now.add(const Duration(days: 3, hours: 2)),
        location: 'High School Auditorium',
        type: 'Meeting',
      ),
    ]);

    _posts.addAll(
      List.generate(
        6,
        (i) => PostModel(
          id: _uuid.v4(),
          authorId: 'user_$i',
          content: 'Sample announcement #${i + 1} — welcome to FBLA Connect!',
          createdAt: now.subtract(Duration(days: i)),
          likes: i * 2,
        ),
      ),
    );

    _resources.addAll([
      ResourceModel(
        id: _uuid.v4(),
        title: 'FBLA Competitive Events Guide',
        description: 'A comprehensive guide to prepare.',
        url: 'https://example.com/fbla_guide.pdf',
        category: 'Guides',
      ),
      ResourceModel(
        id: _uuid.v4(),
        title: 'Presentation Templates',
        description: 'Google Slides templates for presentations.',
        url: 'https://example.com/templates.zip',
        category: 'Templates',
      ),
      ResourceModel(
        id: _uuid.v4(),
        title: 'Sample FBLA Handbook (PDF)',
        description: 'A short handbook for chapter officers.',
        url:
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        category: 'Guides',
      ),
      ResourceModel(
        id: _uuid.v4(),
        title: 'Event Planning Checklist',
        description: 'Checklist to plan successful events.',
        url: 'https://example.com/checklist.pdf',
        category: 'Checklists',
      ),
    ]);
  }

  @override
  Future<List<EventModel>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_events);
  }

  @override
  Future<List<PostModel>> fetchPosts({int page = 0, int pageSize = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, _posts.length);
    if (start >= _posts.length) return [];
    return _posts.sublist(start, end);
  }

  @override
  Future<List<ResourceModel>> fetchResources() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_resources);
  }

  @override
  Future<void> addPost(String authorId, String content) async {
    final post = PostModel(
      id: _uuid.v4(),
      authorId: authorId,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, post);
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    // simple in-memory user stub
    return AppUser(
      id: 'local_user',
      displayName: 'Local User',
      email: 'local@example.com',
    );
  }

  @override
  Future<void> saveUser(AppUser user) async {
    // In-memory save is a no-op for demo
    return;
  }
}
