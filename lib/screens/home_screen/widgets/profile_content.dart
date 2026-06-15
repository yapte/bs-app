import 'package:flutter/material.dart';

import '../../../theme.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        ProfileSummaryCard(),
        SizedBox(height: 14),
        ProfileMetric(title: 'Баланс', value: '12 400 ₽'),
        ProfileMetric(title: 'Бонусы', value: '860'),
        ProfileMetric(title: 'Любимая услуга', value: 'Гидротерапия'),
      ],
    );
  }
}

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: SpaThemeColors.blue,
              child: Text(
                'AM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Анна Михайлова',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '+7 (906) 639-52-42',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMetric extends StatelessWidget {
  const ProfileMetric({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}
