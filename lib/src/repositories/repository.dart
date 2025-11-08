import '../models/event_model.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/resource_model.dart';

abstract class Repository {
  // Events
  Future<List<EventModel>> fetchEvents();

  // Posts/News
  Future<List<PostModel>> fetchPosts({int page = 0, int pageSize = 10});
  Future<void> addPost(String authorId, String content);

  // Resources
  Future<List<ResourceModel>> fetchResources();

  // User profiles
  Future<AppUser?> getUser(String uid);
  Future<void> saveUser(AppUser user);
}
