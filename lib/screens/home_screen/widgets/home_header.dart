import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.title,
    required this.onLogoutSelected,
    super.key,
  });

  final String title;
  final VoidCallback onLogoutSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          PopupMenuButton<_HomeMenuAction>(
            icon: const Icon(Icons.more_vert),
            tooltip: '\u041C\u0435\u043D\u044E',
            onSelected: (action) {
              switch (action) {
                case _HomeMenuAction.logout:
                  onLogoutSelected();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _HomeMenuAction.logout,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout),
                  title: Text('\u0412\u044B\u0439\u0442\u0438'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _HomeMenuAction { logout }
