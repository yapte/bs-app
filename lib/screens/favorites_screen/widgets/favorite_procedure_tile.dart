import 'package:flutter/material.dart';

import '../../../app_routes.dart';
import '../../../common/models/catalog_models.dart';
import '../../../common/widgets/favorite_toggle_button.dart';

class FavoriteProcedureTile extends StatelessWidget {
  const FavoriteProcedureTile({required this.procedure, super.key});

  final Procedure procedure;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRoutes.procedureDetails(procedure.id)),
        title: Text(
          procedure.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('${procedure.duration} · ${procedure.price} ₽'),
        trailing: FavoriteToggleButton(
          procedureId: procedure.id,
          compact: true,
        ),
      ),
    );
  }
}
