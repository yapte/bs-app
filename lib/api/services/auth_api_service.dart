import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class AuthApiService {
  const AuthApiService(this._client);

  final ApiClient _client;

  Future<AuthSession> login(LoginCredentials credentials) async {
    return AuthResponseDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/auth/login',
          body: {'email': credentials.email, 'password': credentials.password},
        ),
      ),
    ).toDomain();
  }

  Future<void> logout() {
    return _client.post('/auth/logout', authenticated: true).then((_) {});
  }

  Future<UserAccount> getProfile() async {
    return UserDto.fromJson(
      requireJsonMap(await _client.get('/auth/profile', authenticated: true)),
    ).toDomain();
  }
}
