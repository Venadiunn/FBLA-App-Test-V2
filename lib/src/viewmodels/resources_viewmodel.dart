import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resource_model.dart';
import '../repositories/repository.dart';
import '../providers.dart';

final resourcesViewModelProvider = ChangeNotifierProvider<ResourcesViewModel>((
  ref,
) {
  final repo = ref.read(repositoryProvider);
  return ResourcesViewModel(repo);
});

class ResourcesViewModel extends ChangeNotifier {
  final Repository _repo;
  List<ResourceModel> _all = [];
  List<ResourceModel> filtered = [];
  bool loading = false;
  String query = '';
  String category = 'All';

  ResourcesViewModel(this._repo);

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      _all = await _repo.fetchResources();
      applyFilters();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void applyFilters() {
    var list = _all;
    if (category != 'All') {
      list = list.where((r) => r.category == category).toList();
    }
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list
          .where(
            (r) =>
                r.title.toLowerCase().contains(q) ||
                r.description.toLowerCase().contains(q),
          )
          .toList();
    }
    filtered = list;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    applyFilters();
  }

  void setCategory(String c) {
    category = c;
    applyFilters();
  }

  List<String> get categories {
    final set = <String>{'All'};
    for (final r in _all) {
      set.add(r.category);
    }
    return set.toList();
  }
}

final resourcesProvider = FutureProvider<List<ResourceModel>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.fetchResources();
});
