import 'package:flutter/material.dart';

import '../../../theme.dart';

class ProcedureDetailsFeatures extends StatelessWidget {
  const ProcedureDetailsFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Что входит', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const _FeatureRow(
            icon: Icons.water_drop_outlined,
            title: 'Мягкая подготовка',
            text:
                'Администратор уточнит пожелания, а специалист подберет комфортный темп процедуры.',
          ),
          const _FeatureRow(
            icon: Icons.air_outlined,
            title: 'Расслабляющая атмосфера',
            text:
                'Тихий кабинет, спокойный свет и аккуратный ритм помогают быстрее отключиться от суеты.',
          ),
          const _FeatureRow(
            icon: Icons.favorite_border,
            title: 'Забота после процедуры',
            text:
                'Подскажем, как продлить эффект и какие процедуры лучше сочетать между собой.',
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: SpaThemeColors.blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SpaThemeColors.blueDark, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(text, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
