import 'package:flutter/material.dart';

import '../../data/favorites/mock_favorites_service.dart';
import '../../theme.dart';

class FavoriteToggleButton extends StatelessWidget {
  const FavoriteToggleButton({
    required this.procedureId,
    this.compact = false,
    super.key,
  });

  final String procedureId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MockFavoritesService.instance,
      builder: (context, _) {
        final isFavorite = MockFavoritesService.instance.isFavorite(
          procedureId,
        );

        if (compact) {
          return IconButton(
            onPressed: () =>
                MockFavoritesService.instance.toggleFavorite(procedureId),
            tooltip: isFavorite
                ? 'Убрать из избранного'
                : 'Добавить в избранное',
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? SpaThemeColors.gold : SpaThemeColors.blue,
            ),
          );
        }

        return OutlinedButton.icon(
          onPressed: () =>
              MockFavoritesService.instance.toggleFavorite(procedureId),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? SpaThemeColors.gold : SpaThemeColors.blue,
          ),
          label: Text(isFavorite ? 'В избранном' : 'Добавить в избранное'),
        );
      },
    );
  }
}
