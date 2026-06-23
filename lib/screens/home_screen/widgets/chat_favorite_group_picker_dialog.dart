import 'package:flutter/material.dart';

import '../../../common/models/models.dart';
import '../../../theme.dart';

class ChatFavoriteGroupPickerDialog extends StatelessWidget {
  const ChatFavoriteGroupPickerDialog({required this.groups, super.key});

  final List<ApiFavoriteGroup> groups;

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
        body: groups.isEmpty
            ? const Center(child: Text('Пока нет избранных групп'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: groups.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final group = groups[index];
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
                      subtitle: Text('${group.procedures.length} процедур'),
                      trailing: const Icon(
                        Icons.add,
                        color: SpaThemeColors.blue,
                      ),
                      onTap: () => Navigator.of(context).pop(group),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
