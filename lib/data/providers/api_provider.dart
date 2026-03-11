import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../core/utils/widgets/common_widgets/custom_exeption_handle.dart';
import 'api_interpreter.dart';
import 'api_response.dart';

// ApiConfig

class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;
  final Map<String, String> defaultHeaders;

  const ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });
}

// ApiClient — pure HTTP layer, zero domain logic

class ApiClient {
  final ApiConfig config;
  final List<ApiInterceptor> _interceptors = [];
  late final http.Client _httpClient;

  ApiClient({required this.config}) {
    _httpClient = http.Client();
    assert(() {
      addInterceptor(LoggerInterceptor());
      return true;
    }());
  }

  void addInterceptor(ApiInterceptor interceptor) =>
      _interceptors.add(interceptor);

  Future<ApiResponse<String>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final request =
        ApiRequest(path: path, headers: headers, queryParams: queryParams);
    for (final i in _interceptors) {
      i.onRequest(request);
    }
    return _executeWithRetry(request, attempt: 0);
  }

  Future<ApiResponse<String>> _executeWithRetry(
    ApiRequest request, {
    required int attempt,
  }) async {
    try {
      final uri = _buildUri(request.path, request.queryParams);
      final mergedHeaders = {...config.defaultHeaders, ...?request.headers};

      final sw = Stopwatch()..start();
      final response = await _httpClient
          .get(uri, headers: mergedHeaders)
          .timeout(config.timeout);
      sw.stop();

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<String>(
          data: response.body,
          statusCode: response.statusCode,
          headers: response.headers,
          duration: sw.elapsed,
        );
        for (final i in _interceptors) {
          i.onResponse(apiResponse);
        }
        return apiResponse;
      }

      if (response.statusCode >= 500 && attempt < config.maxRetries) {
        await Future.delayed(config.retryDelay * (attempt + 1));
        return _executeWithRetry(request, attempt: attempt + 1);
      }

      throw ServerException(
        'Server returned ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on SocketException {
      const err = NetworkException(
          'No internet connection. Please check your network.');
      for (final i in _interceptors) {
        i.onError(err);
      }
      if (attempt < config.maxRetries) {
        await Future.delayed(config.retryDelay);
        return _executeWithRetry(request, attempt: attempt + 1);
      }
      throw err;
    } on TimeoutException {
      const err = TimeoutException('Request timed out. Please try again.');
      for (final i in _interceptors) {
        i.onError(err);
      }
      throw err;
    } catch (e) {
      if (e is ApiException) {
        for (final i in _interceptors) {
          i.onError(e);
        }
        rethrow;
      }
      final err = ApiException('Unexpected error: $e', endpoint: request.path);
      for (final i in _interceptors) {
        i.onError(err);
      }
      throw err;
    }
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final base = Uri.parse('${config.baseUrl}$path');
    if (queryParams == null || queryParams.isEmpty) return base;
    return base.replace(
      queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  void dispose() => _httpClient.close();
}

// ApiProvider — singleton that exposes the configured ApiClient

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  factory ApiProvider() => _instance;
  ApiProvider._internal();

  final ApiClient client = ApiClient(
    config: const ApiConfig(
      baseUrl: AppConstants.baseUrl,
      timeout: Duration(seconds: 15),
      maxRetries: 3,
      retryDelay: Duration(seconds: 2),
    ),
  );

  void dispose() => client.dispose();
}
