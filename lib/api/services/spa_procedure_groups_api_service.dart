import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class SpaProcedureGroupsApiService {
  const SpaProcedureGroupsApiService(this._client);

  final ApiClient _client;

  Future<List<SpaProcedureGroup>> getAll() async {
    return requireJsonList(await _client.get('/spa-procedure-groups'))
        .map(SpaProcedureGroupDto.fromJson)
        .map((item) => item.toDomain())
        .toList();
  }

  Future<SpaProcedureGroup> create(CreateSpaProcedureGroup value) async {
    return SpaProcedureGroupDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/spa-procedure-groups',
          body: {'name': value.name, 'description': value.description},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<SpaProcedureGroup> getById(int id) async {
    return SpaProcedureGroupDto.fromJson(
      requireJsonMap(await _client.get('/spa-procedure-groups/$id')),
    ).toDomain();
  }

  Future<SpaProcedureGroup> update(
    int id,
    UpdateSpaProcedureGroup value,
  ) async {
    return SpaProcedureGroupDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/spa-procedure-groups/$id',
          body: {
            if (value.name != null) 'name': value.name,
            if (value.description != null) 'description': value.description,
          },
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/spa-procedure-groups/$id', authenticated: true);
  }
}
