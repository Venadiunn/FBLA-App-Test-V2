import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/in_memory_repository.dart';
import 'repositories/repository.dart';
import 'repositories/firestore_repository.dart';

// Toggle this to true to use Firestore-backed repository (once Firebase is configured)
final useFirestoreProvider = Provider<bool>((ref) => false);

final inMemoryRepoProvider = Provider<Repository>(
  (ref) => InMemoryRepository(),
);
final firestoreRepoProvider = Provider<Repository>(
  (ref) => FirestoreRepository(),
);

final repositoryProvider = Provider<Repository>((ref) {
  final useFirestore = ref.watch(useFirestoreProvider);
  return useFirestore
      ? ref.watch(firestoreRepoProvider)
      : ref.watch(inMemoryRepoProvider);
});
