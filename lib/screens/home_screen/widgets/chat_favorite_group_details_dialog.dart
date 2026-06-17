import 'package:flutter/material.dart';

import '../../../app_routes.dart';
import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/favorites/favorites_models.dart';
import '../../../theme.dart';

class ChatFavoriteGroupDetailsDialog extends StatelessWidget {
  const ChatFavoriteGroupDetailsDialog({required this.group, super.key});

  final FavoriteGroup group;

  @override
  Widget build(BuildContext context) {
    final procedures = [
      for (final procedureId in group.procedureIds)
        if (findProcedureInCatalog(procedureId) case final entry?)
          entry.procedure,
    ];

    return AlertDialog(
      title: Text(group.title),
      content: SizedBox(
        width: double.maxFinite,
        child: procedures.isEmpty
            ? const Text('В группе пока нет процедур')
            : ListView.separated(
                shrinkWrap: true,
                itemCount: procedures.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final procedure = procedures[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.spa_outlined,
                      color: SpaThemeColors.gold,
                    ),
                    title: Text(procedure.title),
                    subtitle: Text(
                      '${procedure.duration} · ${procedure.price} ₽',
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.procedureDetails(procedure.id));
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}
