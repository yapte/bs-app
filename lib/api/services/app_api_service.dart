import '../api_client.dart';

class AppApiService {
  const AppApiService(this._client);

  final ApiClient _client;

  Future<Object?> getHello() {
    return _client.get('/');
  }
}
