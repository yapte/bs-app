import '../../common/models/models.dart';
import '../api_client.dart';
import '../api_query.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class UsersApiService {
  const UsersApiService(this._client);

  final ApiClient _client;

  Future<PageResult<UserAccount>> getAll([
    PageQuery query = const PageQuery(),
  ]) async {
    final dto = parsePage(
      await _client.get('/users', query: pageQuery(query)),
      UserDto.fromJson,
    );
    return PageResult(
      total: dto.total,
      items: dto.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<UserAccount> create(CreateUser value) async {
    return UserDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/users',
          body: ApiRequestDto.createUser(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<UserAccount> getById(int id) async {
    return UserDto.fromJson(
      requireJsonMap(await _client.get('/users/$id')),
    ).toDomain();
  }

  Future<UserAccount> update(int id, UpdateUser value) async {
    return UserDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/users/$id',
          body: ApiRequestDto.updateUser(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<UserAccount> resetPassword(int id, String password) async {
    return UserDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/users/$id/password',
          body: {'password': password},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/users/$id', authenticated: true);
  }
}
