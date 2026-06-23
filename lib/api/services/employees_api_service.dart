import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class EmployeesApiService {
  const EmployeesApiService(this._client);

  final ApiClient _client;

  Future<List<Employee>> getAll() async {
    return requireJsonList(
      await _client.get('/employees'),
    ).map(EmployeeDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<Employee> create(CreateEmployee value) async {
    return EmployeeDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/employees',
          body: ApiRequestDto.createEmployee(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<Employee> getMe() async {
    return EmployeeDto.fromJson(
      requireJsonMap(await _client.get('/employees/me', authenticated: true)),
    ).toDomain();
  }

  Future<Employee> getById(int id) async {
    return EmployeeDto.fromJson(
      requireJsonMap(await _client.get('/employees/$id')),
    ).toDomain();
  }

  Future<Employee> update(int id, UpdateEmployee value) async {
    return EmployeeDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/employees/$id',
          body: ApiRequestDto.updateEmployee(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/employees/$id', authenticated: true);
  }
}
