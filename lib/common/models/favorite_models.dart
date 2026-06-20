import 'spa_procedure_models.dart';

class ApiFavoriteGroup {
  const ApiFavoriteGroup({
    required this.id,
    required this.title,
    required this.procedures,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final List<FavoriteProcedure> procedures;
  final DateTime createdAt;
  final DateTime updatedAt;
}
