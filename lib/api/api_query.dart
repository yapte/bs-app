import '../common/models/models.dart';

Map<String, Object?> pageQuery(PageQuery query) => {
  if (query.sort != null) 'sort': query.sort,
  if (query.sortDirection != null) 'sortDirection': query.sortDirection,
  if (query.search != null && query.search!.isNotEmpty) 'search': query.search,
  'itemsPerPage': query.itemsPerPage,
  'page': query.page,
};
