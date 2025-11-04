import 'package:flutter/material.dart';

import '../services/storage.dart';

class ProfileEditPage extends StatefulWidget {
  static const route = '/profile-edit';
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppStorage.loadProfile().then((p) {
      nameCtrl.text = p['name'] ?? '';
      emailCtrl.text = p['email'] ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await AppStorage.saveProfile({'name': nameCtrl.text.trim(), 'email': emailCtrl.text.trim()});
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const Spacer(),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: _save, child: const Text('Save'))),
          ],
        ),
      ),
    );
  }
}


