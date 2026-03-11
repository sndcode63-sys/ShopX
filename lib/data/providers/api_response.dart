// Request / Response Models

class ApiRequest {
  final String path;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParams;

  const ApiRequest({
    required this.path,
    this.headers,
    this.queryParams,
  });
}

class ApiResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, String> headers;
  final Duration duration;

  const ApiResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
    required this.duration,
  });
}