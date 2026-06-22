import '../api/api.dart';
import '../common/models/models.dart';
import 'token_storage.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login(LoginCredentials credentials);

  Future<void> logout();
}

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({
    required AuthApiService authApiService,
    required TokenStorage tokenStorage,
  }) : _authApiService = authApiService,
       _tokenStorage = tokenStorage;

  final AuthApiService _authApiService;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthSession> login(LoginCredentials credentials) async {
    final session = await _authApiService.login(credentials);
    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    return session;
  }

  @override
  Future<void> logout() async {
    try {
      await _authApiService.logout();
    } catch (_) {
      // Local logout must still complete if the token is expired or offline.
    } finally {
      await _tokenStorage.clear();
    }
  }
}
