import 'package:flutter/material.dart';

import '../../../common/models/models.dart';
import '../../../theme.dart';

class ProcedurePickerDialog extends StatefulWidget {
  const ProcedurePickerDialog({required this.procedures, super.key});

  final List<SpaProcedure> procedures;

  @override
  State<ProcedurePickerDialog> createState() => _ProcedurePickerDialogState();
}

class _ProcedurePickerDialogState extends State<ProcedurePickerDialog> {
  final _searchController = TextEditingController();

  List<SpaProcedure> get _filteredProcedures {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.procedures;
    }
    return widget.procedures.where((procedure) {
      return procedure.name.toLowerCase().contains(query) ||
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
                  final procedure = procedures[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        procedure.name,
                        style: const TextStyle(
                          color: SpaThemeColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${procedure.durationMinutes} мин · '
                        '${procedure.price.toStringAsFixed(0)} ₽',
                      ),
                      onTap: () => Navigator.of(context).pop(procedure),
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
