import 'package:flutter/material.dart';

import '../../../common/models/catalog_models.dart';
import '../../../data/favorites/mock_favorites_service.dart';
import '../../../theme.dart';

class AddToFavoriteGroupDialog extends StatelessWidget {
  const AddToFavoriteGroupDialog({required this.procedure, super.key});

  final Procedure procedure;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MockFavoritesService.instance,
      builder: (context, _) {
        final groups = MockFavoritesService.instance.groups;

        return AlertDialog(
          title: const Text('Добавить в группу'),
          content: SizedBox(
            width: double.maxFinite,
            child: groups.isEmpty
                ? const Text('Пока нет избранных групп.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final selected = MockFavoritesService.instance.isInGroup(
                        group.id,
                        procedure.id,
                      );

                      return ListTile(
                        leading: Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.folder_special_outlined,
                          color: selected
                              ? SpaThemeColors.gold
                              : SpaThemeColors.blue,
                        ),
                        title: Text(group.title),
                        subtitle: Text('${group.procedureIds.length} процедур'),
                        onTap: selected
                            ? null
                            : () {
                                MockFavoritesService.instance
                                    .addProcedureToGroup(
                                      groupId: group.id,
                                      procedureId: procedure.id,
                                    );
                                Navigator.of(context).pop();
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
      },
    );
  }
}
