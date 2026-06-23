import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class FilesApiService {
  const FilesApiService(this._client);

  final ApiClient _client;

  Future<StoredFile> upload(String filePath) async {
    return StoredFileDto.fromJson(
      requireJsonMap(
        await _client.uploadFile(
          '/files',
          filePath: filePath,
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<PageResult<StoredFile>> getAll(
    PageQuery query, {
    String? mimeType,
    int? uploadedByUserId,
  }) async {
    final page = parsePage(
      await _client.get(
        '/files',
        query: {
          'sort': query.sort,
          'sortDirection': query.sortDirection,
          'search': query.search,
          'itemsPerPage': query.itemsPerPage,
          'page': query.page,
          'mimeType': mimeType,
          'uploadedByUserId': uploadedByUserId,
        },
        authenticated: true,
      ),
      StoredFileDto.fromJson,
    );
    return PageResult(
      total: page.total,
      items: page.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<StoredFile> getById(int id) async {
    return StoredFileDto.fromJson(
      requireJsonMap(await _client.get('/files/$id', authenticated: true)),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/files/$id', authenticated: true);
  }
}
