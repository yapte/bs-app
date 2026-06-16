import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/catalog/catalog_mock_data.dart';
import 'widgets/procedure_details_features.dart';
import 'widgets/procedure_details_info.dart';
import 'widgets/procedure_details_slider.dart';

class ProcedureDetailsScreen extends StatelessWidget {
  const ProcedureDetailsScreen({required this.procedureId, super.key});

  final String procedureId;

  @override
  Widget build(BuildContext context) {
    final entry = findProcedureInCatalog(procedureId);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Процедура')),
        body: const Center(child: Text('Процедура не найдена')),
      );
    }

    final group = entry.group;
    final procedure = entry.procedure;

    return Scaffold(
      appBar: AppBar(title: Text(procedure.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          const ProcedureDetailsSlider(),
          ProcedureDetailsInfo(group: group, procedure: procedure),
          const ProcedureDetailsFeatures(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.chatWithProcedureDraft(procedure.id),
                (route) => false,
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('ОБСУДИТЬ С АДМИНИСТРАТОРОМ'),
            ),
          ),
        ],
      ),
    );
  }
}
