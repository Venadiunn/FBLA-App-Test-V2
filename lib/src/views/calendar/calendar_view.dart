import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/events_viewmodel.dart';
import '../../models/event_model.dart';
import '../../services/share_service.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: eventsAsync.when(
        data: (events) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: events.length,
          itemBuilder: (context, i) => EventTile(event: events[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class EventTile extends ConsumerWidget {
  final EventModel event;
  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final share = ref.read(shareServiceProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text('${event.startsAt} • ${event.location}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await share.shareEvent(event);
              },
            ),
            IconButton(
              icon: const Icon(Icons.event_available),
              onPressed: () {
                // RSVP placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('RSVP saved (demo)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
