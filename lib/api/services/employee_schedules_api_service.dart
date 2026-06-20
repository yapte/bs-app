import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class EmployeeSchedulesApiService {
  const EmployeeSchedulesApiService(this._client);

  final ApiClient _client;

  Future<List<EmployeeSchedule>> getAll() async {
    return requireJsonList(
      await _client.get('/employee-schedules'),
    ).map(EmployeeScheduleDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<EmployeeSchedule> create(CreateEmployeeSchedule value) async {
    return EmployeeScheduleDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/employee-schedules',
          body: ApiRequestDto.createEmployeeSchedule(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<List<EmployeeScheduleDay>> search(
    EmployeeScheduleSearch search,
  ) async {
    final payload = await _client.post(
      '/employee-schedules/search',
      body: {
        'employeeIds': search.employeeIds,
        'dates': search.dates.map((date) => date.toIso8601String()).toList(),
      },
    );
    return requireJsonList(payload)
        .map(EmployeeScheduleDayDto.fromJson)
        .map((item) => item.toDomain())
        .toList();
  }

  Future<EmployeeSchedule> update(int id, UpdateEmployeeSchedule value) async {
    return EmployeeScheduleDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/employee-schedules/$id',
          body: ApiRequestDto.updateEmployeeSchedule(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/employee-schedules/$id', authenticated: true);
  }
}
