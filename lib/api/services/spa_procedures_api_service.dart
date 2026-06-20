import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class SpaProceduresApiService {
  const SpaProceduresApiService(this._client);

  final ApiClient _client;

  Future<List<SpaProcedure>> getAll() async {
    return requireJsonList(
      await _client.get('/spa-procedures'),
    ).map(SpaProcedureDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<SpaProcedure> create(CreateSpaProcedure value) async {
    return SpaProcedureDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/spa-procedures',
          body: ApiRequestDto.createSpaProcedure(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<SpaProcedure> getById(int id) async {
    return SpaProcedureDto.fromJson(
      requireJsonMap(await _client.get('/spa-procedures/$id')),
    ).toDomain();
  }

  Future<SpaProcedure> update(int id, UpdateSpaProcedure value) async {
    return SpaProcedureDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/spa-procedures/$id',
          body: ApiRequestDto.updateSpaProcedure(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/spa-procedures/$id', authenticated: true);
  }
}
