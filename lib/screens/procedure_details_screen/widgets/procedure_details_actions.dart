import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_models.dart';
import '../../../widgets/favorite_toggle_button.dart';
import 'add_to_favorite_group_dialog.dart';

class ProcedureDetailsActions extends StatelessWidget {
  const ProcedureDetailsActions({required this.procedure, super.key});

  final Procedure procedure;

  Future<void> _showGroupDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AddToFavoriteGroupDialog(procedure: procedure),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FavoriteToggleButton(procedureId: procedure.id),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showGroupDialog(context),
            icon: const Icon(Icons.create_new_folder_outlined),
            label: const Text('Добавить в избранную группу'),
          ),
        ],
      ),
    );
  }
}
