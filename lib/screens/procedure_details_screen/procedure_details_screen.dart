import 'package:flutter/material.dart';

import '../../data/catalog/catalog_models.dart';
import 'widgets/procedure_details_features.dart';
import 'widgets/procedure_details_info.dart';
import 'widgets/procedure_details_slider.dart';

class ProcedureDetailsScreen extends StatelessWidget {
  const ProcedureDetailsScreen({
    required this.group,
    required this.procedure,
    super.key,
  });

  final CatalogGroup group;
  final Procedure procedure;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('ОБСУДИТЬ С АДМИНИСТРАТОРОМ'),
            ),
          ),
        ],
      ),
    );
  }
}
