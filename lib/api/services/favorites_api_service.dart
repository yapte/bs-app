import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class FavoritesApiService {
  const FavoritesApiService(this._client);

  final ApiClient _client;

  Future<List<FavoriteProcedure>> getAll() async {
    return requireJsonList(await _client.get('/favorites', authenticated: true))
        .map(FavoriteProcedureDto.fromJson)
        .map((item) => item.toDomain())
        .toList();
  }

  Future<FavoriteProcedure> add(String procedureId) async {
    return FavoriteProcedureDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/favorites',
          body: {'procedureId': procedureId},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> remove(String procedureId) {
    return _client.delete(
      '/favorites/${Uri.encodeComponent(procedureId)}',
      authenticated: true,
    );
  }
}
