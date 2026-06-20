import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../common/models/catalog_models.dart';
import '../../../theme.dart';

class ProcedurePickerDialog extends StatefulWidget {
  const ProcedurePickerDialog({super.key});

  @override
  State<ProcedurePickerDialog> createState() => _ProcedurePickerDialogState();
}

class _ProcedurePickerDialogState extends State<ProcedurePickerDialog> {
  final _searchController = TextEditingController();

  List<ProcedureSelection> get _filteredProcedures {
    final query = _searchController.text.trim().toLowerCase();
    final procedures = [
      for (final group in catalogGroups)
        for (final procedure in group.procedures)
          ProcedureSelection(group: group, procedure: procedure),
    ];

    if (query.isEmpty) {
      return procedures;
    }

    return procedures.where((entry) {
      return entry.procedure.title.toLowerCase().contains(query) ||
          entry.procedure.description.toLowerCase().contains(query) ||
          entry.group.title.toLowerCase().contains(query);
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
          title: const Text('Выбор процедуры'),
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                itemCount: procedures.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = procedures[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        entry.procedure.title,
                        style: const TextStyle(
                          color: SpaThemeColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${entry.group.title} · '
                        '${entry.procedure.duration} · '
                        '${entry.procedure.price} ₽',
                      ),
                      onTap: () => Navigator.of(context).pop(entry),
                    ),
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

class ProcedureSelection {
  const ProcedureSelection({required this.group, required this.procedure});

  final CatalogGroup group;
  final Procedure procedure;
}
