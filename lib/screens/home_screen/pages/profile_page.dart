import 'package:flutter/material.dart';

import '../../../api/api_scope.dart';
import '../widgets/logout_confirmation_sheet.dart';
import '../widgets/profile_content.dart';
import '../widgets/profile_hero_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showLogoutSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return LogoutConfirmationSheet(
          onConfirm: () async {
            Navigator.of(sheetContext).pop();
            await ApiScope.authRepositoryOf(context).logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
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
