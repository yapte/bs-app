import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

typedef AccessTokenProvider = FutureOr<String?> Function();

class ApiClient {
  ApiClient({
    required String baseUrl,
    http.Client? httpClient,
    this.accessTokenProvider,
    this.defaultHeaders = const {},
  }) : baseUri = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
       _httpClient = httpClient ?? http.Client();

  final Uri baseUri;
  final AccessTokenProvider? accessTokenProvider;
  final Map<String, String> defaultHeaders;
  final http.Client _httpClient;

  Future<Object?> get(
    String path, {
    Map<String, Object?> query = const {},
    bool authenticated = false,
  }) {
    return request('GET', path, query: query, authenticated: authenticated);
  }

  Future<Object?> post(
    String path, {
    Map<String, Object?> query = const {},
    Object? body,
    bool authenticated = false,
  }) {
    return request(
      'POST',
      path,
      query: query,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<Object?> patch(
    String path, {
    Map<String, Object?> query = const {},
    Object? body,
    bool authenticated = false,
  }) {
    return request(
      'PATCH',
      path,
      query: query,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<void> delete(
    String path, {
    Map<String, Object?> query = const {},
    bool authenticated = false,
  }) async {
    await request('DELETE', path, query: query, authenticated: authenticated);
  }

  Future<Object?> uploadFile(
    String path, {
    required String filePath,
    String fieldName = 'file',
    Map<String, String> fields = const {},
    bool authenticated = false,
  }) async {
    final request = http.MultipartRequest('POST', _buildUri(path, const {}));
    request.headers.addAll({'accept': 'application/json', ...defaultHeaders});
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    await _addAuthorization(request, authenticated);

    final streamedResponse = await _httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    final payload = _decodeBody(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toException(response.statusCode, payload);
    }

    return payload;
  }

  Future<Object?> request(
    String method,
    String path, {
    Map<String, Object?> query = const {},
    Object? body,
    bool authenticated = false,
  }) async {
    final request = http.Request(method, _buildUri(path, query));
    request.headers.addAll({'accept': 'application/json', ...defaultHeaders});

    if (body != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    await _addAuthorization(request, authenticated);

    final streamedResponse = await _httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    final payload = _decodeBody(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toException(response.statusCode, payload);
    }

    return payload;
  }

  void close() {
    _httpClient.close();
  }

  Future<void> _addAuthorization(
    http.BaseRequest request,
    bool authenticated,
  ) async {
    if (!authenticated) {
      return;
    }

    final token = await accessTokenProvider?.call();
    if (token == null || token.isEmpty) {
      throw const ApiException(
        statusCode: 401,
        code: 'AUTH_TOKEN_MISSING',
        message: 'Для запроса требуется access token',
      );
    }
    request.headers['authorization'] = 'Bearer $token';
  }

  Uri _buildUri(String path, Map<String, Object?> query) {
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    final uri = baseUri.resolve(relativePath);
    final queryParameters = <String, List<String>>{};

    for (final entry in query.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }

      if (value is Iterable) {
        final values = value.map((item) => item.toString()).toList();
        if (values.isNotEmpty) {
          queryParameters[entry.key] = values;
        }
      } else {
        queryParameters[entry.key] = [value.toString()];
      }
    }

    return uri.replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  Object? _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }

  ApiException _toException(int statusCode, Object? payload) {
    if (payload is Map) {
      final map = payload.map((key, value) => MapEntry(key.toString(), value));
      return ApiException(
        statusCode: statusCode,
        code: map['code']?.toString(),
        message:
            map['message']?.toString() ??
            map['error']?.toString() ??
            'Ошибка API',
        payload: payload,
      );
    }

    return ApiException(
      statusCode: statusCode,
      message: payload?.toString() ?? 'Ошибка API',
      payload: payload,
    );
  }
}
