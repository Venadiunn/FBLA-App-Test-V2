import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/resources_viewmodel.dart';
// ...existing code...
import 'resource_detail_page.dart';

class ResourceListView extends ConsumerStatefulWidget {
  const ResourceListView({super.key});

  @override
  ConsumerState<ResourceListView> createState() => _ResourceListViewState();
}

class _ResourceListViewState extends ConsumerState<ResourceListView> {
  late final vm = ref.read(resourcesViewModelProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => vm.load());
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(resourcesViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search resources',
              ),
              onChanged: model.setQuery,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: model.category,
              isExpanded: true,
              items: model.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => model.setCategory(v ?? 'All'),
            ),
          ),
          Expanded(
            child: model.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: model.filtered.length,
                    itemBuilder: (context, i) {
                      final r = model.filtered[i];
                      return ListTile(
                        title: Text(r.title),
                        subtitle: Text(r.category),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ResourceDetailPage(resource: r),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
