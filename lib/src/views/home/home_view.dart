import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../../models/post_model.dart';
import '../../services/share_service.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider(0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('FBLA Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.of(context).pushNamed('/calendar'),
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: posts.length,
          itemBuilder: (context, i) => PostTile(post: posts[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              Navigator.of(context).pushNamed('/calendar');
              break;
            case 2:
              Navigator.of(context).pushNamed('/resources');
              break;
            case 3:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (c) {
              final ctrl = TextEditingController();
              return AlertDialog(
                title: const Text('Create Post'),
                content: TextField(controller: ctrl, maxLines: 3),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(c).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(c).pop(ctrl.text),
                    child: const Text('Post'),
                  ),
                ],
              );
            },
          );
          if (result != null && result.trim().isNotEmpty) {
            final add = ref.read(addPostProvider);
            await add('local_user', result.trim());
            // Refresh
            ref.invalidate(postsProvider(0));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostTile extends ConsumerWidget {
  final PostModel post;
  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final share = ref.read(shareServiceProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'by ${post.authorId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Icon(Icons.favorite_border),
                    const SizedBox(width: 6),
                    Text('${post.likes}'),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        await share.sharePost(post);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
