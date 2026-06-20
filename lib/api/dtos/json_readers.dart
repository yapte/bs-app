typedef JsonMap = Map<String, dynamic>;

int readInt(Object? value, [int fallback = 0]) {
  return switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text) ?? fallback,
    _ => fallback,
  };
}

double readDouble(Object? value, [double fallback = 0]) {
  return switch (value) {
    num number => number.toDouble(),
    String text => double.tryParse(text) ?? fallback,
    _ => fallback,
  };
}

String readString(Object? value, [String fallback = '']) {
  return value?.toString() ?? fallback;
}

DateTime readDate(Object? value) {
  return DateTime.tryParse(readString(value)) ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

DateTime? readNullableDate(Object? value) {
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(readString(value));
}

int? readNullableInt(Object? value) {
  if (value == null) {
    return null;
  }
  return switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text),
    JsonMap map => readNullableInt(map['id']),
    Map map => readNullableInt(map['id']),
    _ => null,
  };
}

double? readNullableDouble(Object? value) {
  if (value == null) {
    return null;
  }
  return switch (value) {
    num number => number.toDouble(),
    String text => double.tryParse(text),
    _ => null,
  };
}

String? readNullableString(Object? value) {
  return value?.toString();
}

List<int> readIntList(Object? value) {
  if (value is! List) {
    return const [];
  }
  return value.map(readInt).toList();
}

JsonMap readMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return const {};
}
