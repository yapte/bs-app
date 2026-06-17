import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController(text: 'Анна Михайлова');
  final _emailController = TextEditingController(
    text: 'anna.mikhailova@example.ru',
  );
  final _phoneController = TextEditingController(text: '+7 (906) 639-52-42');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактирование профиля')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'ФИО',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _phoneController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Телефон',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check),
            label: const Text('СОХРАНИТЬ'),
          ),
        ],
      ),
    );
  }
}
