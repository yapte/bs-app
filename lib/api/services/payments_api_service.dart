import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class PaymentsApiService {
  const PaymentsApiService(this._client);

  final ApiClient _client;

  Future<List<Payment>> getAll() async {
    return requireJsonList(
      await _client.get('/payments'),
    ).map(PaymentDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<Payment> create(CreatePayment value) async {
    return PaymentDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/payments',
          body: ApiRequestDto.createPayment(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<Payment> getById(int id) async {
    return PaymentDto.fromJson(
      requireJsonMap(await _client.get('/payments/$id')),
    ).toDomain();
  }

  Future<Payment> update(int id, UpdatePayment value) async {
    return PaymentDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/payments/$id',
          body: ApiRequestDto.updatePayment(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/payments/$id', authenticated: true);
  }
}
