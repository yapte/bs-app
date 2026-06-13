import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'home_header.dart';
import 'logout_confirmation_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showLogoutSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return LogoutConfirmationSheet(
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(onLogoutSelected: () => _showLogoutSheet(context)),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                '\u041F\u0440\u043E\u0444\u0438\u043B\u044C',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              Card(
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
                              '\u0410\u043D\u043D\u0430 '
                              '\u041C\u0438\u0445\u0430\u0439\u043B\u043E'
                              '\u0432\u0430',
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
              ),
              const SizedBox(height: 14),
              const _ProfileMetric(
                title: '\u0411\u0430\u043B\u0430\u043D\u0441',
                value: '12 400 \u20BD',
              ),
              const _ProfileMetric(
                title: '\u0411\u043E\u043D\u0443\u0441\u044B',
                value: '860',
              ),
              const _ProfileMetric(
                title:
                    '\u041B\u044E\u0431\u0438\u043C\u0430\u044F '
                    '\u0443\u0441\u043B\u0443\u0433\u0430',
                value:
                    '\u0413\u0438\u0434\u0440\u043E\u0442\u0435\u0440\u0430'
                    '\u043F\u0438\u044F',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.title, required this.value});

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
