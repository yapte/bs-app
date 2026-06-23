import '../../common/models/models.dart';
import '../api_client.dart';
import '../api_query.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class ClientsApiService {
  const ClientsApiService(this._client);

  final ApiClient _client;

  Future<PageResult<Client>> getAll([
    PageQuery query = const PageQuery(),
  ]) async {
    final dto = parsePage(
      await _client.get('/clients', query: pageQuery(query)),
      ClientDto.fromJson,
    );
    return PageResult(
      total: dto.total,
      items: dto.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<Client> create(CreateClient value) async {
    final json = requireJsonMap(
      await _client.post(
        '/clients',
        body: ApiRequestDto.createClient(value),
        authenticated: true,
      ),
    );
    return ClientDto.fromJson(json).toDomain();
  }

  Future<Client> getMe() async {
    return ClientDto.fromJson(
      requireJsonMap(await _client.get('/clients/me', authenticated: true)),
    ).toDomain();
  }

  Future<Client> getById(int id) async {
    return ClientDto.fromJson(
      requireJsonMap(await _client.get('/clients/$id')),
    ).toDomain();
  }

  Future<Client> update(int id, UpdateClient value) async {
    final json = requireJsonMap(
      await _client.patch(
        '/clients/$id',
        body: ApiRequestDto.updateClient(value),
        authenticated: true,
      ),
    );
    return ClientDto.fromJson(json).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/clients/$id', authenticated: true);
  }
}
