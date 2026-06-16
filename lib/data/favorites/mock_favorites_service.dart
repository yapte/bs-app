import 'package:flutter/foundation.dart';

import 'favorites_models.dart';

class MockFavoritesService extends ChangeNotifier {
  MockFavoritesService._();

  static final MockFavoritesService instance = MockFavoritesService._();

  final Set<String> _favoriteProcedureIds = {'sarga-terapiya', 'pinda-svedana'};

  var _groups = const [
    FavoriteGroup(
      id: 'relax',
      title: 'Для расслабления',
      procedureIds: ['sarga-terapiya', 'pinda-svedana'],
    ),
    FavoriteGroup(
      id: 'water',
      title: 'Водные процедуры',
      procedureIds: ['vakuumnyy-gidromassazh', 'morskaya-vanna'],
    ),
  ];

  List<String> get favoriteProcedureIds => _favoriteProcedureIds.toList();

  List<FavoriteGroup> get groups => List.unmodifiable(_groups);

  bool isFavorite(String procedureId) {
    return _favoriteProcedureIds.contains(procedureId);
  }

  bool isInGroup(String groupId, String procedureId) {
    return _groups.any(
      (group) =>
          group.id == groupId && group.procedureIds.contains(procedureId),
    );
  }

  void toggleFavorite(String procedureId) {
    if (_favoriteProcedureIds.contains(procedureId)) {
      removeFavorite(procedureId);
      return;
    }

    _favoriteProcedureIds.add(procedureId);
    notifyListeners();
  }

  void addFavorite(String procedureId) {
    if (_favoriteProcedureIds.add(procedureId)) {
      notifyListeners();
    }
  }

  void removeFavorite(String procedureId) {
    final removed = _favoriteProcedureIds.remove(procedureId);
    var changedGroups = false;

    _groups = [
      for (final group in _groups)
        if (group.procedureIds.contains(procedureId))
          () {
            changedGroups = true;
            return group.copyWith(
              procedureIds: [
                for (final id in group.procedureIds)
                  if (id != procedureId) id,
              ],
            );
          }()
        else
          group,
    ];

    if (removed || changedGroups) {
      notifyListeners();
    }
  }

  void createGroup(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    _groups = [
      ..._groups,
      FavoriteGroup(
        id: 'group-${DateTime.now().microsecondsSinceEpoch}',
        title: trimmedTitle,
        procedureIds: const [],
      ),
    ];
    notifyListeners();
  }

  void renameGroup({required String groupId, required String title}) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    var changed = false;
    _groups = [
      for (final group in _groups)
        if (group.id == groupId && group.title != trimmedTitle)
          () {
            changed = true;
            return group.copyWith(title: trimmedTitle);
          }()
        else
          group,
    ];

    if (changed) {
      notifyListeners();
    }
  }

  void addProcedureToGroup({
    required String groupId,
    required String procedureId,
  }) {
    var changed = false;
    _groups = [
      for (final group in _groups)
        if (group.id == groupId && !group.procedureIds.contains(procedureId))
          () {
            changed = true;
            return group.copyWith(
              procedureIds: [...group.procedureIds, procedureId],
            );
          }()
        else
          group,
    ];

    if (changed) {
      _favoriteProcedureIds.add(procedureId);
      notifyListeners();
    }
  }
}
