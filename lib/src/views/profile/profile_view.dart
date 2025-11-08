import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _chapterCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();

  bool _loading = false;
  File? _pickedImage;

  Future<void> _loadUser() async {
    // For demo, assume current user id is 'local_user'
    final repo = ref.read(repositoryProvider);
    final user = await repo.getUser('local_user');
    if (user != null) {
      _nameCtrl.text = user.displayName;
      _emailCtrl.text = user.email;
      _schoolCtrl.text = user.school;
      _chapterCtrl.text = user.chapter;
      _roleCtrl.text = user.role;
      _bioCtrl.text = user.bio;
      _avatarCtrl.text = user.avatarUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _schoolCtrl.dispose();
    _chapterCtrl.dispose();
    _roleCtrl.dispose();
    _bioCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _schoolCtrl,
                decoration: const InputDecoration(labelText: 'School'),
              ),
              TextFormField(
                controller: _chapterCtrl,
                decoration: const InputDecoration(labelText: 'Chapter'),
              ),
              TextFormField(
                controller: _roleCtrl,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              Row(
                children: [
                  _pickedImage == null
                      ? CircleAvatar(
                          radius: 28,
                          backgroundImage: _avatarCtrl.text.isNotEmpty
                              ? NetworkImage(_avatarCtrl.text)
                              : null,
                          child: _avatarCtrl.text.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundImage: FileImage(_pickedImage!),
                        ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Pick & Upload'),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final xfile = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (xfile == null) return;
                      setState(() => _pickedImage = File(xfile.path));
                      // Upload via StorageService
                      setState(() => _loading = true);
                      final storage = ref.read(storageServiceProvider);
                      try {
                        final userId = 'local_user';
                        final url = await storage.uploadAvatar(
                          userId,
                          _pickedImage!,
                        );
                        if (!mounted) return;
                        setState(() => _avatarCtrl.text = url);
                      } catch (e) {
                        if (!mounted) return;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload failed: $e')),
                          );
                        });
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _loading = true);
                        final repo = ref.read(repositoryProvider);
                        final user = AppUser(
                          id: 'local_user',
                          displayName: _nameCtrl.text.trim(),
                          email: _emailCtrl.text.trim(),
                          school: _schoolCtrl.text.trim(),
                          chapter: _chapterCtrl.text.trim(),
                          role: _roleCtrl.text.trim(),
                          avatarUrl: _avatarCtrl.text.trim(),
                          bio: _bioCtrl.text.trim(),
                        );
                        final messenger = ScaffoldMessenger.of(context);
                        await repo.saveUser(user);
                        if (!mounted) return;
                        setState(() => _loading = false);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Profile saved (demo)')),
                        );
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
