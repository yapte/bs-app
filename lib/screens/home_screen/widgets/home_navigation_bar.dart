import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        _svgDestination(
          'assets/profile_icon.svg',
          '\u041F\u0440\u043E\u0444\u0438\u043B\u044C',
        ),
        _svgDestination(
          'assets/schedule_icon.svg',
          '\u0420\u0430\u0441\u043F\u0438\u0441\u0430\u043D'
              '\u0438\u0435',
        ),
        _svgDestination(
          'assets/catalog_icon.svg',
          '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
        ),
        _svgDestination('assets/chat_icon.svg', '\u0427\u0430\u0442'),
      ],
    );
  }
}

NavigationDestination _svgDestination(String assetName, String label) {
  return NavigationDestination(
    icon: _NavIcon(assetName: assetName),
    selectedIcon: _NavIcon(assetName: assetName, selected: true),
    label: label,
  );
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.assetName, this.selected = false});

  final String assetName;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: 26,
      height: 26,
      colorFilter: selected
          ? const ColorFilter.mode(SpaThemeColors.gold, BlendMode.srcIn)
          : null,
    );
  }
}
