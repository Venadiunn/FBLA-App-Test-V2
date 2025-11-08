import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../providers.dart';

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.fetchEvents();
});
