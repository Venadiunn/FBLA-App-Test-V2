import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String school;
  final String chapter;
  final String role;
  final String avatarUrl;
  final String bio;

  AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.school = '',
    this.chapter = '',
    this.role = '',
    this.avatarUrl = '',
    this.bio = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'school': school,
    'chapter': chapter,
    'role': role,
    'avatarUrl': avatarUrl,
    'bio': bio,
  };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
    id: m['id'] ?? '',
    displayName: m['displayName'] ?? '',
    email: m['email'] ?? '',
    school: m['school'] ?? '',
    chapter: m['chapter'] ?? '',
    role: m['role'] ?? '',
    avatarUrl: m['avatarUrl'] ?? '',
    bio: m['bio'] ?? '',
  );

  factory AppUser.fromFirestore(DocumentSnapshot doc) =>
      AppUser.fromMap(doc.data() as Map<String, dynamic>);
}
