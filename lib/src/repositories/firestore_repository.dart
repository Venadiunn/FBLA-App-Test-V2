import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/post_model.dart';
import '../models/resource_model.dart';
import 'repository.dart';

class FirestoreRepository implements Repository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ResourceModel>? _resourcesCache;

  FirestoreRepository() {
    // Enable offline persistence
    try {
      _db.settings = const Settings(persistenceEnabled: true);
    } catch (_) {
      // already set or platform doesn't support
    }
  }

  @override
  Future<List<EventModel>> fetchEvents() async {
    // TODO: implement Firestore query and mapping
    final snap = await _db.collection('events').get();
    return snap.docs.map((d) => EventModel.fromMap(d.data())).toList();
  }

  @override
  Future<void> addPost(String authorId, String content) async {
    final doc = _db.collection('posts').doc();
    await doc.set({
      'id': doc.id,
      'authorId': authorId,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
      'likes': 0,
    });
  }

  @override
  Future<List<PostModel>> fetchPosts({int page = 0, int pageSize = 10}) async {
    // Pagination example: order by createdAt desc and use startAfter for paging
    final snap = await _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .get();
    return snap.docs.map((d) => PostModel.fromMap(d.data())).toList();
  }

  @override
  Future<List<ResourceModel>> fetchResources() async {
    // Return cached copy when available
    if (_resourcesCache != null) return List.from(_resourcesCache!);
    final snap = await _db.collection('resources').get();
    final list = snap.docs.map((d) => ResourceModel.fromMap(d.data())).toList();
    _resourcesCache = list;
    return list;
  }

  /// Force refresh from server
  Future<List<ResourceModel>> refreshResources() async {
    final snap = await _db
        .collection('resources')
        .get(GetOptions(source: Source.server));
    final list = snap.docs.map((d) => ResourceModel.fromMap(d.data())).toList();
    _resourcesCache = list;
    return list;
  }

  // User profile CRUD
  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> saveUser(AppUser user) async {
    await _db
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
