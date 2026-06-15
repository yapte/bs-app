import 'package:flutter/material.dart';

import '../widgets/home_header.dart';
import '../widgets/logout_confirmation_sheet.dart';
import '../widgets/profile_content.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showLogoutSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return LogoutConfirmationSheet(
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(
          title: '\u041F\u0440\u043E\u0444\u0438\u043B\u044C',
          onLogoutSelected: () => _showLogoutSheet(context),
        ),
        Expanded(child: ProfileContent()),
      ],
    );
  }
}
