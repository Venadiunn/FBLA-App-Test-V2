import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadAvatar(String userId, File file) async {
    final ref = _storage.ref().child('avatars').child('$userId.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return url;
  }
}
