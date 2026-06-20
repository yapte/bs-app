import '../../common/models/models.dart';
import '../api_client.dart';
import '../api_query.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class AppointmentsApiService {
  const AppointmentsApiService(this._client);

  final ApiClient _client;

  Future<PageResult<Appointment>> getAll([
    AppointmentQuery query = const AppointmentQuery(),
  ]) async {
    final dto = parsePage(
      await _client.get(
        '/appointments',
        query: {
          ...pageQuery(query),
          if (query.statuses.isNotEmpty) 'statuses': query.statuses,
          if (query.employeeIds.isNotEmpty) 'employeeIds': query.employeeIds,
          if (query.clientId != null) 'clientId': query.clientId,
          if (query.spaProcedureId != null)
            'spaProcedureId': query.spaProcedureId,
          if (query.from != null) 'from': query.from!.toIso8601String(),
          if (query.to != null) 'to': query.to!.toIso8601String(),
        },
      ),
      AppointmentDto.fromJson,
    );
    return PageResult(
      total: dto.total,
      items: dto.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<Appointment> create(CreateAppointment value) async {
    return AppointmentDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/appointments',
          body: ApiRequestDto.createAppointment(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<List<Appointment>> getMyAssignedServices() async {
    return requireJsonList(
      await _client.get('/appointments/my', authenticated: true),
    ).map(AppointmentDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<Appointment> getById(int id) async {
    return AppointmentDto.fromJson(
      requireJsonMap(await _client.get('/appointments/$id')),
    ).toDomain();
  }

  Future<Appointment> update(int id, UpdateAppointment value) async {
    return AppointmentDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/appointments/$id',
          body: ApiRequestDto.updateAppointment(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/appointments/$id', authenticated: true);
  }

  Future<List<Appointment>> search(AppointmentSearch search) async {
    final payload = await _client.post(
      '/appointments/search',
      body: {
        'employeeIds': search.employeeIds,
        'from': search.from.toIso8601String(),
        'to': search.to.toIso8601String(),
        if (search.statuses.isNotEmpty) 'statuses': search.statuses,
      },
    );
    return requireJsonList(
      payload,
    ).map(AppointmentDto.fromJson).map((item) => item.toDomain()).toList();
  }
}
