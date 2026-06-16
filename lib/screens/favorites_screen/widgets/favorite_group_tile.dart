import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/favorites/favorites_models.dart';
import '../../../theme.dart';
import 'favorite_procedure_tile.dart';

class FavoriteGroupTile extends StatelessWidget {
  const FavoriteGroupTile({
    required this.group,
    required this.onAddProcedure,
    required this.onRename,
    super.key,
  });

  final FavoriteGroup group;
  final VoidCallback onAddProcedure;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final procedures = [
      for (final procedureId in group.procedureIds)
        if (findProcedureInCatalog(procedureId) case final entry?)
          entry.procedure,
    ];

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: SpaThemeColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.folder_special_outlined,
              color: SpaThemeColors.gold,
            ),
          ),
          title: Text(
            group.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text('${procedures.length} процедур'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onRename,
                tooltip: 'Переименовать группу',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: SpaThemeColors.inkMuted,
                ),
              ),
              IconButton(
                onPressed: onAddProcedure,
                tooltip: 'Добавить процедуру',
                icon: const Icon(Icons.add, color: SpaThemeColors.blue),
              ),
              const Icon(Icons.expand_more),
            ],
          ),
          children: [
            if (procedures.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('В группе пока нет процедур'),
                ),
              )
            else
              for (final procedure in procedures)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FavoriteProcedureTile(procedure: procedure),
                ),
          ],
        ),
      ),
    );
  }
}
