class PageResult<T> {
  const PageResult({required this.total, required this.items});

  final int total;
  final List<T> items;
}

class PageQuery {
  const PageQuery({
    this.sort,
    this.sortDirection,
    this.search,
    this.itemsPerPage = 20,
    this.page = 1,
  });

  final String? sort;
  final String? sortDirection;
  final String? search;
  final int itemsPerPage;
  final int page;
}

class AuditData {
  const AuditData({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;
}
