import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post_model.dart';
import '../models/event_model.dart';

final shareServiceProvider = Provider((ref) => ShareService());

class ShareService {
  String formatPostShare(PostModel post) {
    final when = post.createdAt.toLocal();
    return '${post.content}\n\n— Shared from FBLA Connect\nPosted on ${when.toString()}';
  }

  String formatEventShare(EventModel event) {
    final starts = event.startsAt.toLocal();
    final ends = event.endsAt.toLocal();
    return '${event.title}\n${event.description}\n${starts.toLocal()} - ${ends.toLocal()}\nLocation: ${event.location}\n\nShared via FBLA Connect';
  }

  Future<void> sharePost(PostModel post) async {
    final text = formatPostShare(post);
    await Share.share(text);
  }

  Future<void> shareEvent(EventModel event) async {
    final text = formatEventShare(event);
    await Share.share(text);
  }
}
