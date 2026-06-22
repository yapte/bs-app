import 'dart:convert';

import 'package:bs_app/api/api.dart';
import 'package:bs_app/auth/auth_repository.dart';
import 'package:bs_app/auth/token_storage.dart';
import 'package:bs_app/common/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'login stores tokens and authenticated requests use access token',
    () async {
      final storage = _MemoryTokenStorage();
      final httpClient = MockClient((request) async {
        if (request.url.path == '/auth/login') {
          expect(jsonDecode(request.body), {
            'email': 'admin@example.com',
            'password': 'password',
          });
          return http.Response(
            jsonEncode({
              'accessToken': 'access-token',
              'refreshToken': 'refresh-token',
              'user': _userJson,
            }),
            200,
          );
        }

        expect(request.url.path, '/auth/profile');
        expect(request.headers['authorization'], 'Bearer access-token');
        return http.Response(jsonEncode(_userJson), 200);
      });
      final client = ApiClient(
        baseUrl: 'https://example.test',
        httpClient: httpClient,
        accessTokenProvider: storage.readAccessToken,
      );
      final authService = AuthApiService(client);
      final repository = ApiAuthRepository(
        authApiService: authService,
        tokenStorage: storage,
      );

      await repository.login(
        const LoginCredentials(
          email: 'admin@example.com',
          password: 'password',
        ),
      );
      await authService.getProfile();

      expect(await storage.readAccessToken(), 'access-token');
      expect(await storage.readRefreshToken(), 'refresh-token');
    },
  );
}

final _userJson = {
  'id': 1,
  'name': 'Admin',
  'email': 'admin@example.com',
  'role': 'admin',
  'retryCount': 0,
  'createdAt': '2026-06-22T00:00:00.000Z',
  'updatedAt': '2026-06-22T00:00:00.000Z',
  'deletedAt': null,
  'createdBy': null,
  'updatedBy': null,
  'deletedBy': null,
};

class _MemoryTokenStorage implements TokenStorage {
  String? accessToken;
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
