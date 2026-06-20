class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.code,
    this.payload,
  });

  final int statusCode;
  final String message;
  final String? code;
  final Object? payload;

  @override
  String toString() {
    final errorCode = code == null ? '' : ' [$code]';
    return 'ApiException($statusCode$errorCode): $message';
  }
}
