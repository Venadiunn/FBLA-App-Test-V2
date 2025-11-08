import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/resources_viewmodel.dart';
import '../../models/resource_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesView extends ConsumerWidget {
  const ResourcesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: resourcesAsync.when(
        data: (resources) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: resources.length,
          itemBuilder: (context, i) => ResourceTile(resource: resources[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class ResourceTile extends StatefulWidget {
  final ResourceModel resource;
  const ResourceTile({super.key, required this.resource});

  @override
  State<ResourceTile> createState() => _ResourceTileState();
}

class _ResourceTileState extends State<ResourceTile> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(widget.resource.title),
        subtitle: Text(widget.resource.category),
        trailing: IconButton(
          icon: _loading
              ? const CircularProgressIndicator()
              : const Icon(Icons.open_in_new),
          onPressed: () async {
            setState(() => _loading = true);
            final messenger = ScaffoldMessenger.of(context);
            final uri = Uri.parse(widget.resource.url);
            final can = await canLaunchUrl(uri);
            if (can) {
              await launchUrl(uri);
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('Cannot open link')),
              );
            }
            if (mounted) setState(() => _loading = false);
          },
        ),
      ),
    );
  }
}
