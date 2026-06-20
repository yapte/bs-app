import 'package:flutter/material.dart';

import '../../../app_routes.dart';
import '../../../common/models/catalog_models.dart';
import '../../../theme.dart';
import '../../../common/widgets/favorite_toggle_button.dart';

enum CatalogViewMode { grid, table }

class CatalogGroupSection extends StatelessWidget {
  const CatalogGroupSection({
    required this.group,
    required this.viewMode,
    super.key,
  });

  final CatalogGroup group;
  final CatalogViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            group.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          switch (viewMode) {
            CatalogViewMode.grid => _ProcedureGrid(group: group),
            CatalogViewMode.table => _ProcedureTable(group: group),
          },
        ],
      ),
    );
  }
}

class _ProcedureGrid extends StatelessWidget {
  const _ProcedureGrid({required this.group});

  final CatalogGroup group;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: group.procedures.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) =>
          _ProcedureCard(group: group, procedure: group.procedures[index]),
    );
  }
}

class _ProcedureTable extends StatelessWidget {
  const _ProcedureTable({required this.group});

  final CatalogGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final procedure in group.procedures)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ProcedureRow(group: group, procedure: procedure),
          ),
      ],
    );
  }
}

class _ProcedureCard extends StatelessWidget {
  const _ProcedureCard({required this.group, required this.procedure});

  final CatalogGroup group;
  final Procedure procedure;

  void _openDetails(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.procedureDetails(procedure.id));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => _openDetails(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 42),
                    child: _ProcedureTitle(procedure: procedure),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      procedure.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.45,
                      ),
                    ),
                  ),
                  const Divider(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          procedure.duration,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${procedure.price} ₽',
                        style: const TextStyle(
                          color: Color(0xFFB4930B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: FavoriteToggleButton(
              procedureId: procedure.id,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcedureRow extends StatelessWidget {
  const _ProcedureRow({required this.group, required this.procedure});

  final CatalogGroup group;
  final Procedure procedure;

  void _openDetails(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.procedureDetails(procedure.id));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProcedureTitle(procedure: procedure),
                    const SizedBox(height: 6),
                    Text(
                      procedure.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ProcedureMeta(
                          icon: Icons.schedule_outlined,
                          text: procedure.duration,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${procedure.price} ₽',
                          style: const TextStyle(
                            color: Color(0xFFB4930B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FavoriteToggleButton(procedureId: procedure.id, compact: true),
              const Icon(Icons.chevron_right, color: SpaThemeColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcedureMeta extends StatelessWidget {
  const _ProcedureMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: SpaThemeColors.gold, size: 18),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ProcedureTitle extends StatelessWidget {
  const _ProcedureTitle({required this.procedure});

  final Procedure procedure;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: SpaThemeColors.blue,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );

    if (procedure.badge == null) {
      return Text(
        procedure.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      );
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.only(right: 6, bottom: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF58B431),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'НОВИНКА',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          TextSpan(text: procedure.title, style: titleStyle),
        ],
      ),
    );
  }
}
