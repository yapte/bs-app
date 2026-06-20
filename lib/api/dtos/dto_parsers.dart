import 'api_response_dtos.dart';
import 'json_readers.dart';

JsonMap requireJsonMap(Object? payload) {
  if (payload is Map) {
    return readMap(payload);
  }
  throw const FormatException('Ожидался JSON-объект');
}

List<JsonMap> requireJsonList(Object? payload) {
  if (payload is! List) {
    throw const FormatException('Ожидался JSON-массив');
  }
  return payload.map(readMap).toList();
}

PageDto<T> parsePage<T>(Object? payload, T Function(JsonMap json) fromJson) {
  final json = requireJsonMap(payload);
  final items = (json['items'] as List? ?? const [])
      .map((item) => fromJson(readMap(item)))
      .toList();
  return PageDto(total: readInt(json['total']), items: items);
}
