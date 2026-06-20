class FavoriteGroup {
  const FavoriteGroup({
    required this.id,
    required this.title,
    required this.procedureIds,
  });

  final String id;
  final String title;
  final List<String> procedureIds;

  FavoriteGroup copyWith({
    String? id,
    String? title,
    List<String>? procedureIds,
  }) {
    return FavoriteGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      procedureIds: procedureIds ?? this.procedureIds,
    );
  }
}
