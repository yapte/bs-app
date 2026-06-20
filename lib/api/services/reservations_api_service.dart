import '../../common/models/models.dart';
import '../api_client.dart';
import '../api_query.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class ReservationsApiService {
  const ReservationsApiService(this._client);

  final ApiClient _client;

  Future<PageResult<Reservation>> getAll([
    ReservationQuery query = const ReservationQuery(),
  ]) async {
    final dto = parsePage(
      await _client.get(
        '/reservations',
        query: {
          ...pageQuery(query),
          if (query.statuses.isNotEmpty) 'statuses': query.statuses,
          if (query.roomId != null) 'roomId': query.roomId,
          if (query.clientId != null) 'clientId': query.clientId,
          if (query.from != null) 'from': query.from!.toIso8601String(),
          if (query.to != null) 'to': query.to!.toIso8601String(),
        },
      ),
      ReservationDto.fromJson,
    );
    return PageResult(
      total: dto.total,
      items: dto.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<Reservation> create(CreateReservation value) async {
    return ReservationDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/reservations',
          body: ApiRequestDto.createReservation(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<Reservation> getById(int id) async {
    return ReservationDto.fromJson(
      requireJsonMap(await _client.get('/reservations/$id')),
    ).toDomain();
  }

  Future<Reservation> update(int id, UpdateReservation value) async {
    return ReservationDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/reservations/$id',
          body: ApiRequestDto.updateReservation(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/reservations/$id', authenticated: true);
  }
}
