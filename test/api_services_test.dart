import 'dart:convert';

import 'package:bs_app/api/api.dart';
import 'package:bs_app/common/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('API services', () {
    test(
      'clients service maps DTOs to domain models and sends query',
      () async {
        final httpClient = MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/clients');
          expect(request.url.queryParameters['page'], '2');
          expect(request.url.queryParameters['search'], 'Анна');

          return http.Response(
            jsonEncode({
              'total': 1,
              'items': [
                {
                  'id': 7,
                  'name': 'Анна Михайлова',
                  'email': 'anna@example.ru',
                  'phone': '+79066395242',
                  'birth': '1990-06-20T00:00:00.000Z',
                  'sex': 'female',
                  'userId': 11,
                  'comment': null,
                  'createdAt': '2026-06-20T08:00:00.000Z',
                  'updatedAt': '2026-06-20T08:00:00.000Z',
                  'deletedAt': null,
                  'createdBy': null,
                  'updatedBy': null,
                  'deletedBy': null,
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final client = ApiClient(
          baseUrl: 'https://example.test',
          httpClient: httpClient,
        );

        final result = await ClientsApiService(
          client,
        ).getAll(const PageQuery(page: 2, search: 'Анна'));

        expect(result.total, 1);
        expect(result.items.single.id, 7);
        expect(result.items.single.name, 'Анна Михайлова');
      },
    );

    test('authenticated request adds bearer token and JSON body', () async {
      final httpClient = MockClient((request) async {
        expect(request.headers['authorization'], 'Bearer access-token');
        expect(jsonDecode(request.body), {'procedureId': 'pinda-svedana'});

        return http.Response(
          jsonEncode({
            'id': 'pinda-svedana',
            'title': 'Пинда Сведана',
            'description': 'Описание',
            'duration': '80 минут',
            'price': 5200,
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ApiClient(
        baseUrl: 'https://example.test/api',
        httpClient: httpClient,
        accessTokenProvider: () => 'access-token',
      );

      final result = await FavoritesApiService(client).add('pinda-svedana');

      expect(result.id, 'pinda-svedana');
      expect(result.price, 5200);
    });

    test('domain error response becomes ApiException', () async {
      final client = ApiClient(
        baseUrl: 'https://example.test',
        httpClient: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'code': 'FAVORITE_GROUP_NOT_FOUND',
              'message': 'Группа не найдена',
            }),
            404,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ),
        ),
        accessTokenProvider: () => 'access-token',
      );

      expect(
        () => FavoriteGroupsApiService(client).getById(42),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 404)
              .having(
                (error) => error.code,
                'code',
                'FAVORITE_GROUP_NOT_FOUND',
              ),
        ),
      );
    });
  });
}
