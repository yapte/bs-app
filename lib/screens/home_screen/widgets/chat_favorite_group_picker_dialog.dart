import 'package:flutter/material.dart';

import '../../../data/favorites/favorites_models.dart';
import '../../../data/favorites/mock_favorites_service.dart';
import '../../../theme.dart';

class ChatFavoriteGroupPickerDialog extends StatelessWidget {
  const ChatFavoriteGroupPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выбор группы'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: AnimatedBuilder(
          animation: MockFavoritesService.instance,
          builder: (context, _) {
            final groups = MockFavoritesService.instance.groups;

            if (groups.isEmpty) {
              return const Center(child: Text('Пока нет избранных групп'));
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: groups.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final group = groups[index];
                return _FavoriteGroupOption(group: group);
              },
            );
          },
        ),
      ),
    );
  }
}

class _FavoriteGroupOption extends StatelessWidget {
  const _FavoriteGroupOption({required this.group});

  final FavoriteGroup group;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
        title: Text(group.title),
        subtitle: Text('${group.procedureIds.length} процедур'),
        trailing: const Icon(Icons.add, color: SpaThemeColors.blue),
        onTap: () => Navigator.of(context).pop(group),
      ),
    );
  }
}
