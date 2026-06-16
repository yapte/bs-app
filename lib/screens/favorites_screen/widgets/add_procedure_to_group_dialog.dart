import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/catalog/catalog_models.dart';
import '../../../data/favorites/favorites_models.dart';
import '../../../data/favorites/mock_favorites_service.dart';
import '../../../theme.dart';

class AddProcedureToGroupDialog extends StatefulWidget {
  const AddProcedureToGroupDialog({required this.group, super.key});

  final FavoriteGroup group;

  @override
  State<AddProcedureToGroupDialog> createState() =>
      _AddProcedureToGroupDialogState();
}

class _AddProcedureToGroupDialogState extends State<AddProcedureToGroupDialog> {
  final _searchController = TextEditingController();

  List<Procedure> get _filteredProcedures {
    final query = _searchController.text.trim().toLowerCase();
    final procedures = [for (final group in catalogGroups) ...group.procedures];

    if (query.isEmpty) {
      return procedures;
    }

    return procedures.where((procedure) {
      return procedure.title.toLowerCase().contains(query) ||
          procedure.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final procedures = _filteredProcedures;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Добавить в «${widget.group.title}»'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Поиск по процедурам',
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: MockFavoritesService.instance,
                builder: (context, _) {
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                    itemCount: procedures.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final procedure = procedures[index];
                      final selected = MockFavoritesService.instance.isInGroup(
                        widget.group.id,
                        procedure.id,
                      );

                      return Card(
                        child: ListTile(
                          leading: Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: selected
                                ? SpaThemeColors.gold
                                : SpaThemeColors.blue,
                          ),
                          title: Text(
                            procedure.title,
                            style: const TextStyle(
                              color: SpaThemeColors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            '${procedure.duration} · ${procedure.price} ₽',
                          ),
                          onTap: selected
                              ? null
                              : () => MockFavoritesService.instance
                                    .addProcedureToGroup(
                                      groupId: widget.group.id,
                                      procedureId: procedure.id,
                                    ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
