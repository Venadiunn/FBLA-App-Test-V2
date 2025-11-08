import 'package:flutter/material.dart';
import '../../models/resource_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceDetailPage extends StatelessWidget {
  final ResourceModel resource;
  const ResourceDetailPage({super.key, required this.resource});

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.parse(resource.url);
    final messenger = ScaffoldMessenger.of(context);
    if (!await canLaunchUrl(uri)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Cannot open resource')),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(resource.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resource.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              resource.category,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(resource.description),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                    onPressed: () => _openUrl(context),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // share_plus could be used; keep simple for now
                    // final text = '${resource.title} - ${resource.url}';
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
