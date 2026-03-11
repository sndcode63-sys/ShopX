// Custom Exceptions

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;

  const ApiException(
      this.message, {
        this.statusCode,
        this.endpoint,
      });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class TimeoutException extends ApiException {
  const TimeoutException(super.message);
}

class ServerException extends ApiException {
  const ServerException(super.message, {required super.statusCode});
}

class ParseException extends ApiException {
  const ParseException(super.message);
}