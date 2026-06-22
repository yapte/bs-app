/// API configuration
/// Другой сервер можно указать при запуске:
/// flutter run --dart-define=API_BASE_URL=https://example.com
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.bs.injini.ru',
  );
}
