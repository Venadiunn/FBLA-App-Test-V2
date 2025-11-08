import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../providers.dart';

final postsProvider = FutureProvider.family<List<PostModel>, int>((
  ref,
  page,
) async {
  final repo = ref.watch(repositoryProvider);
  return repo.fetchPosts(page: page);
});

final addPostProvider = Provider(
  (ref) => (String authorId, String content) async {
    final repo = ref.read(repositoryProvider);
    await repo.addPost(authorId, content);
  },
);
