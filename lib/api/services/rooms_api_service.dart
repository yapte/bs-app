import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_request_dtos.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';

class RoomsApiService {
  const RoomsApiService(this._client);

  final ApiClient _client;

  Future<List<Room>> getAll() async {
    return requireJsonList(
      await _client.get('/rooms'),
    ).map(RoomDto.fromJson).map((item) => item.toDomain()).toList();
  }

  Future<Room> create(CreateRoom value) async {
    return RoomDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/rooms',
          body: ApiRequestDto.createRoom(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<Room> getById(int id) async {
    return RoomDto.fromJson(
      requireJsonMap(await _client.get('/rooms/$id')),
    ).toDomain();
  }

  Future<Room> update(int id, UpdateRoom value) async {
    return RoomDto.fromJson(
      requireJsonMap(
        await _client.patch(
          '/rooms/$id',
          body: ApiRequestDto.updateRoom(value),
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> delete(int id) {
    return _client.delete('/rooms/$id', authenticated: true);
  }
}
