import 'package:flutter/material.dart';

import '../../../app_routes.dart';
import '../../../theme.dart';

class ProfileFavoriteCard extends StatelessWidget {
  const ProfileFavoriteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.favorites),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: SpaThemeColors.gold.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.favorite, color: SpaThemeColors.gold),
        ),
        title: const Text('Избранное'),
        subtitle: const Text('Процедуры и личные группы'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
