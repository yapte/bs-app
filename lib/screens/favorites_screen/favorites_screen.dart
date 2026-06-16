import 'package:flutter/material.dart';

import '../../data/catalog/catalog_mock_data.dart';
import '../../data/favorites/mock_favorites_service.dart';
import '../../theme.dart';
import 'widgets/add_procedure_to_group_dialog.dart';
import 'widgets/create_favorite_group_dialog.dart';
import 'widgets/favorite_group_tile.dart';
import 'widgets/favorite_procedure_tile.dart';
import 'widgets/rename_favorite_group_dialog.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const CreateFavoriteGroupDialog(),
    );
  }

  Future<void> _showAddProcedureDialog(
    BuildContext context,
    String groupId,
  ) async {
    final group = MockFavoritesService.instance.groups
        .where((group) => group.id == groupId)
        .firstOrNull;
    if (group == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AddProcedureToGroupDialog(group: group),
    );
  }

  Future<void> _showRenameGroupDialog(
    BuildContext context,
    String groupId,
  ) async {
    final group = MockFavoritesService.instance.groups
        .where((group) => group.id == groupId)
        .firstOrNull;
    if (group == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => RenameFavoriteGroupDialog(group: group),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => _showCreateGroupDialog(context),
              tooltip: 'Создать группу',
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: MockFavoritesService.instance,
        builder: (context, _) {
          final favoriteProcedures = [
            for (final id in MockFavoritesService.instance.favoriteProcedureIds)
              if (findProcedureInCatalog(id) case final entry?) entry.procedure,
          ];
          final groups = MockFavoritesService.instance.groups;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              Text(
                'Процедуры',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              if (favoriteProcedures.isEmpty)
                const _EmptyFavoritesCard()
              else
                for (final procedure in favoriteProcedures)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FavoriteProcedureTile(procedure: procedure),
                  ),
              const SizedBox(height: 18),
              Text('Группы', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              if (groups.isEmpty)
                const _EmptyGroupsCard()
              else
                for (final group in groups)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FavoriteGroupTile(
                      group: group,
                      onAddProcedure: () =>
                          _showAddProcedureDialog(context, group.id),
                      onRename: () => _showRenameGroupDialog(context, group.id),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyFavoritesCard extends StatelessWidget {
  const _EmptyFavoritesCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.favorite_border, color: SpaThemeColors.blue),
            SizedBox(width: 12),
            Expanded(child: Text('Добавляйте процедуры из каталога.')),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroupsCard extends StatelessWidget {
  const _EmptyGroupsCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.folder_special_outlined, color: SpaThemeColors.gold),
            SizedBox(width: 12),
            Expanded(child: Text('Создайте группу для личных подборок.')),
          ],
        ),
      ),
    );
  }
}
