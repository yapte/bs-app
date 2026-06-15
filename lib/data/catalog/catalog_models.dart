class CatalogGroup {
  const CatalogGroup({
    required this.id,
    required this.title,
    required this.description,
    required this.procedures,
  });

  final String id;
  final String title;
  final String description;
  final List<Procedure> procedures;
}

class Procedure {
  const Procedure({
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    this.badge,
  });

  final String title;
  final String description;
  final String duration;
  final int price;
  final String? badge;
}
