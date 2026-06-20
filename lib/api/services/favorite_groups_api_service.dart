import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class FavoriteGroupsApiService {
  const FavoriteGroupsApiService(this._client);

  final ApiClient _client;

  Future<List<ApiFavoriteGroup>> getAll() async {
    return requireJsonList(
      await _client.get('/favorite-groups', authenticated: true),
    ).map(FavoriteGroupDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<ApiFavoriteGroup> create(String title) async {
    return FavoriteGroupDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/favorite-groups',
          body: {'title': title},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<ApiFavoriteGroup> getById(int groupId) async {
    return FavoriteGroupDto.fromJson(
      requireJsonMap(
        await _client.get('/favorite-groups/$groupId', authenticated: true),
      ),
    ).toDomain();
  }

  Future<ApiFavoriteGroup> rename(int groupId, String title) async {
    return FavoriteGroupDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/favorite-groups/$groupId',
          body: {'title': title},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int groupId) {
    return _client.delete('/favorite-groups/$groupId', authenticated: true);
  }

  Future<ApiFavoriteGroup> addProcedure(int groupId, String procedureId) async {
    return FavoriteGroupDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/favorite-groups/$groupId/procedures',
          body: {'procedureId': procedureId},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> removeProcedure(int groupId, String procedureId) {
    return _client.delete(
      '/favorite-groups/$groupId/procedures/'
      '${Uri.encodeComponent(procedureId)}',
      authenticated: true,
    );
  }
}
