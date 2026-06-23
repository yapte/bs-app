import 'package:flutter/material.dart';

import '../../../app_routes.dart';
import '../../../common/models/models.dart';
import '../../../theme.dart';

class ChatFavoriteGroupDetailsDialog extends StatelessWidget {
  const ChatFavoriteGroupDetailsDialog({required this.group, super.key});

  final ApiFavoriteGroup group;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(group.title),
      content: SizedBox(
        width: double.maxFinite,
        child: group.procedures.isEmpty
            ? const Text('В группе пока нет процедур')
            : ListView.separated(
                shrinkWrap: true,
                itemCount: group.procedures.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final procedure = group.procedures[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.spa_outlined,
                      color: SpaThemeColors.gold,
                    ),
                    title: Text(procedure.title),
                    subtitle: Text(
                      '${procedure.duration} · '
                      '${procedure.price.toStringAsFixed(0)} ₽',
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
