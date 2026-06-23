import 'dart:convert';

import 'package:bs_app/api/api.dart';
import 'package:bs_app/auth/auth_repository.dart';
import 'package:bs_app/common/models/models.dart';
import 'package:bs_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('navigates from splash to login and home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ApiScope(
        services: _createApiServices(),
        authRepository: _FakeAuthRepository(),
        child: const BigSaltsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0414\u043E\u0431\u0440\u043E '
        '\u043F\u043E\u0436\u0430\u043B\u043E\u0432\u0430\u0442\u044C',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u0412\u041E\u0419\u0422\u0418'));
    await tester.pumpAndSettle();

    expect(find.text('\u0412\u0445\u043E\u0434'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'admin@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.text('ВОЙТИ'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C'),
      findsWidgets,
    );
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(
      find.text('\u0420\u0430\u0441\u043F\u0438\u0441\u0430\u043D\u0438\u0435'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '14 \u0438\u044E\u043D\u044F, '
        '\u043F\u044F\u0442\u043D\u0438\u0446\u0430',
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byTooltip('\u0418\u0441\u0442\u043E\u0440\u0438\u044F'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0418\u0441\u0442\u043E\u0440\u0438\u044F '
        '\u0440\u0430\u0441\u043F\u0438\u0441\u0430\u043D\u0438\u044F',
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byTooltip('\u041E\u0447\u0438\u0441\u0442\u0438\u0442\u044C'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0414\u0430\u0442\u0430 \u00AB\u0421\u00BB '
        '\u043E\u0431\u044F\u0437\u0430\u0442\u0435\u043B\u044C'
        '\u043D\u0430',
      ),
      findsOneWidget,
    );
    final applyButton = tester.widget<ElevatedButton>(
      find.widgetWithText(
        ElevatedButton,
        '\u041F\u0440\u0438\u043C\u0435\u043D\u0438\u0442\u044C',
      ),
    );
    expect(applyButton.onPressed, isNull);

    await tester.tap(find.text('\u041E\u0442\u043C\u0435\u043D\u0430'));
    await tester.pumpAndSettle();

    await tester.tap(
      find
          .text(
            '\u0412\u0430\u043A\u0443\u0443\u043C\u043D\u044B\u0439 '
            '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
            '\u0430\u0436',
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u041A\u0430\u043A '
        '\u043F\u043E\u0434\u0433\u043E\u0442\u043E\u0432\u0438'
        '\u0442\u044C\u0441\u044F',
      ),
      findsOneWidget,
    );

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C').last,
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('\u041A\u0430\u0442\u0430\u043B\u043E\u0433').last,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('\u041C\u0430\u0441\u0441\u0430\u0436\u0438'),
      findsWidgets,
    );
    expect(
      find.textContaining(
        '\u0421\u0410\u0420\u0413\u0410-\u0422\u0415\u0420\u0410\u041F\u0418\u042F',
        findRichText: true,
      ),
      findsOneWidget,
    );

    await tester.tap(
      find
          .textContaining(
            '\u0421\u0410\u0420\u0413\u0410-\u0422\u0415\u0420\u0410\u041F\u0418\u042F',
            findRichText: true,
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0422\u0438\u0445\u0438\u0439 '
        '\u0440\u0438\u0442\u0443\u0430\u043B '
        '\u0432\u043E\u0441\u0441\u0442\u0430\u043D'
        '\u043E\u0432\u043B\u0435\u043D\u0438\u044F',
      ),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.byType(Navigator))).maybePop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('catalog_group_tab_ayurveda')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u041F\u0438\u043D\u0434\u0430 \u0421\u0432\u0435\u0434\u0430\u043D\u0430',
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byTooltip('\u0424\u0438\u043B\u044C\u0442\u0440\u044B'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('\u0424\u0438\u043B\u044C\u0442\u0440\u044B'),
      findsOneWidget,
    );
    expect(
      find.text(
        '\u0414\u043E\u0441\u0442\u0443\u043F\u043D\u044B '
        '\u0441\u0435\u0433\u043E\u0434\u043D\u044F',
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).first, '3500');
    expect(find.text('3500'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.text('\u0427\u0430\u0442').last);
    await tester.pumpAndSettle();

    expect(find.text('\u0427\u0430\u0442'), findsWidgets);
    expect(
      find.text(
        '\u0410\u0434\u043C\u0438\u043D\u0438\u0441\u0442'
        '\u0440\u0430\u0442\u043E\u0440 \u043E\u043D\u043B\u0430'
        '\u0439\u043D',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        '\u0430\u0434\u043C\u0438\u043D\u0438\u0441\u0442'
        '\u0440\u0430\u0442\u043E\u0440 \u0421\u041F\u0410',
        findRichText: true,
      ),
      findsWidgets,
    );

    await tester.tap(find.byIcon(Icons.attachment));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(
        '\u041F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430 '
        '\u0438\u0437 \u043A\u0430\u0442\u0430\u043B\u043E\u0433\u0430',
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0412\u044B\u0431\u043E\u0440 '
        '\u043F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u044B',
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).last, 'Пинда');
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(
        '\u041F\u0438\u043D\u0434\u0430 \u0421\u0432\u0435\u0434\u0430\u043D\u0430',
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0418\u043D\u0442\u0435\u0440\u0435\u0441\u0443\u0435\u0442 '
        '\u044D\u0442\u0430 \u043F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430',
      ),
      findsNothing,
    );
    expect(
      find.text(
        '\u041F\u0438\u043D\u0434\u0430 \u0421\u0432\u0435\u0434\u0430\u043D\u0430',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.attachment));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(
        '\u041F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430 '
        '\u0438\u0437 \u043A\u0430\u0442\u0430\u043B\u043E\u0433\u0430',
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Удвартана');
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('\u0423\u0434\u0432\u0430\u0440\u0442\u0430\u043D\u0430').last,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('\u0423\u0434\u0432\u0430\u0440\u0442\u0430\u043D\u0430'),
      findsOneWidget,
    );

    await tester.tap(
      find
          .byTooltip(
            '\u0423\u0434\u0430\u043B\u0438\u0442\u044C '
            '\u0432\u043B\u043E\u0436\u0435\u043D\u0438\u0435',
          )
          .last,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('\u0423\u0434\u0432\u0430\u0440\u0442\u0430\u043D\u0430'),
      findsNothing,
    );
    expect(
      find.text(
        '\u041F\u0438\u043D\u0434\u0430 \u0421\u0432\u0435\u0434\u0430\u043D\u0430',
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byType(TextField).last,
      '\u0418\u043D\u0442\u0435\u0440\u0435\u0441\u0443\u0435\u0442 '
      '\u044D\u0442\u0430 \u043F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430',
    );
    await tester.tap(find.byIcon(Icons.send).last);
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0418\u043D\u0442\u0435\u0440\u0435\u0441\u0443\u0435\u0442 '
        '\u044D\u0442\u0430 \u043F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430',
      ),
      findsOneWidget,
    );

    await tester.tap(
      find
          .text(
            '\u041F\u0438\u043D\u0434\u0430 \u0421\u0432\u0435\u0434\u0430\u043D\u0430',
          )
          .last,
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0422\u0438\u0445\u0438\u0439 '
        '\u0440\u0438\u0442\u0443\u0430\u043B '
        '\u0432\u043E\u0441\u0441\u0442\u0430\u043D'
        '\u043E\u0432\u043B\u0435\u043D\u0438\u044F',
      ),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.byType(Navigator))).maybePop();
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C').last,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u0412\u044B\u0439\u0442\u0438'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0414\u0435\u0439\u0441\u0442\u0432\u0438\u0442'
        '\u0435\u043B\u044C\u043D\u043E '
        '\u0432\u044B\u0439\u0442\u0438?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u0414\u0430'));
    await tester.pumpAndSettle();

    expect(find.text('\u0412\u0445\u043E\u0434'), findsOneWidget);
  });
}

ApiServices _createApiServices() {
  var nextMessageId = 2;
  final client = ApiClient(
    baseUrl: 'https://example.test',
    accessTokenProvider: () => 'access-token',
    httpClient: MockClient((request) async {
      final path = request.url.path;

      if (path == '/auth/profile') {
        return _jsonResponse(_userJson);
      }
      if (path == '/chats' && request.method == 'GET') {
        return _jsonResponse({
          'total': 1,
          'items': [_chatJson],
        });
      }
      if (path == '/chats/4/messages' && request.method == 'GET') {
        return _jsonResponse({
          'items': request.url.queryParameters.containsKey('afterId')
              ? <Object>[]
              : [_initialMessageJson],
          'hasMore': false,
          'nextCursor': null,
        });
      }
      if (path == '/chats/4/messages' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final attachments = (body['attachments'] as List? ?? const []).map((
          item,
        ) {
          final attachment = item as Map<String, dynamic>;
          final procedureId = attachment['spaProcedureId'] as int?;
          if (procedureId != null) {
            final procedure = _procedures.firstWhere(
              (item) => item['id'] == procedureId,
            );
            return {
              'id': procedureId,
              'type': 'spaProcedure',
              'spaProcedure': {
                'id': procedure['id'],
                'slug': procedure['slug'],
                'name': procedure['name'],
                'duration': procedure['duration'],
                'price': procedure['price'],
              },
            };
          }
          return item;
        }).toList();
        return _jsonResponse({
          'id': nextMessageId++,
          'chatId': 4,
          'author': {'id': 1, 'name': 'Admin', 'role': 'admin'},
          'text': body['text'] ?? '',
          'createdAt': '2026-06-23T10:01:00.000Z',
          'deletedAt': null,
          'attachments': attachments,
        }, statusCode: 201);
      }
      if (path == '/chats/4/read' && request.method == 'PATCH') {
        return http.Response('', 204);
      }
      if (path == '/spa-procedures') {
        return _jsonResponse(_procedures);
      }
      if (path == '/favorite-groups') {
        return _jsonResponse(<Object>[]);
      }

      return _jsonResponse({
        'code': 'NOT_FOUND',
        'message': 'Not found: $path',
      }, statusCode: 404);
    }),
  );
  return ApiServices(client);
}

http.Response _jsonResponse(Object body, {int statusCode = 200}) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

final _userJson = {
  'id': 1,
  'name': 'Admin',
  'email': 'admin@example.com',
  'role': 'admin',
  'retryCount': 0,
  'createdAt': '2026-06-23T10:00:00.000Z',
  'updatedAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'createdBy': null,
  'updatedBy': null,
  'deletedBy': null,
};

final _chatJson = {
  'id': 4,
  'client': {'id': 42, 'name': 'Клиент', 'email': 'client@example.com'},
  'assignedUser': {'id': 1, 'name': 'Admin', 'role': 'admin'},
  'participants': [
    {'id': 1, 'name': 'Admin', 'role': 'admin'},
    {'id': 2, 'name': 'Клиент', 'role': 'guest'},
  ],
  'status': 'open',
  'lastMessageAt': '2026-06-23T10:00:00.000Z',
  'lastMessage': _initialMessageJson,
  'unreadCount': 1,
  'createdAt': '2026-06-23T09:00:00.000Z',
  'updatedAt': '2026-06-23T10:00:00.000Z',
};

final _initialMessageJson = {
  'id': 1,
  'chatId': 4,
  'author': {'id': 1, 'name': 'Admin', 'role': 'admin'},
  'text': 'Здравствуйте! Я администратор СПА.',
  'createdAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'attachments': <Object>[],
};

final _procedures = [
  {
    'id': 15,
    'slug': 'pinda-svedana',
    'name': 'Пинда Сведана',
    'description': 'Описание',
    'duration': 80,
    'price': 5200,
    'spaProcedureGroupId': 1,
    'availableEmployeeIds': <int>[],
    ..._auditJson,
  },
  {
    'id': 16,
    'slug': 'udvartana',
    'name': 'Удвартана',
    'description': 'Описание',
    'duration': 60,
    'price': 4500,
    'spaProcedureGroupId': 1,
    'availableEmployeeIds': <int>[],
    ..._auditJson,
  },
];

final _auditJson = {
  'createdAt': '2026-06-23T10:00:00.000Z',
  'updatedAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'createdBy': null,
  'updatedBy': null,
  'deletedBy': null,
};

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> login(LoginCredentials credentials) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final now = DateTime(2026, 6, 22);
    return AuthSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      user: UserAccount(
        id: 1,
        name: 'Admin',
        email: credentials.email,
        role: 'admin',
        audit: AuditData(createdAt: now, updatedAt: now),
      ),
    );
  }

  @override
  Future<void> logout() async {}
}
