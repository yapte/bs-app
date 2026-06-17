import 'package:flutter/material.dart';

import '../widgets/logout_confirmation_sheet.dart';
import '../widgets/profile_content.dart';
import '../widgets/profile_hero_header.dart';

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
        ProfileHeroHeader(onLogoutSelected: () => _showLogoutSheet(context)),
        const Expanded(child: ProfileContent()),
      ],
    );
  }
}
