import 'package:flutter/material.dart';

class ProfileHeroHeader extends StatelessWidget {
  const ProfileHeroHeader({required this.onLogoutSelected, super.key});

  final VoidCallback onLogoutSelected;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.31;

    return SizedBox(
      height: height.clamp(220.0, 300.0),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/profile_hero.png', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x22000000),
                  Color(0x99000000),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 12,
            top: 12,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Профиль',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                PopupMenuButton<_ProfileMenuAction>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  tooltip: 'Меню',
                  onSelected: (action) {
                    switch (action) {
                      case _ProfileMenuAction.logout:
                        onLogoutSelected();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _ProfileMenuAction.logout,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.logout),
                        title: Text('Выйти'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProfileMenuAction { logout }
