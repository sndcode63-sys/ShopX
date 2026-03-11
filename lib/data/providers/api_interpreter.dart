// Interceptor Interface
import '../../core/utils/widgets/common_widgets/custom_exeption_handle.dart';
import 'api_response.dart';

abstract class ApiInterceptor {
  void onRequest(ApiRequest request) {}

  void onResponse(ApiResponse response) {}

  void onError(ApiException error) {}
}


class LoggerInterceptor implements ApiInterceptor {
  @override
  void onRequest(ApiRequest request) {
    // ignore: avoid_print
    print('┌──────────── API REQUEST ────────────────');
    // ignore: avoid_print
    print('│ → ${request.path}');
    if (request.queryParams?.isNotEmpty == true) {
      // ignore: avoid_print
      print('│ Params: ${request.queryParams}');
    }
    // ignore: avoid_print
    print('└─────────────────────────────────────────');
  }

  @override
  void onResponse(ApiResponse response) {
    // ignore: avoid_print
    print('┌──────────── API RESPONSE ───────────────');
    // ignore: avoid_print
    print('│ ✅ Status: ${response.statusCode}');
    // ignore: avoid_print
    print('│ ⏱ Duration: ${response.duration.inMilliseconds}ms');
    // ignore: avoid_print
    print('└─────────────────────────────────────────');
  }

  @override
  void onError(ApiException error) {
    // ignore: avoid_print
    print('┌──────────── API ERROR ──────────────────');
    // ignore: avoid_print
    print('│ ❌ $error');
    if (error.endpoint != null) {
      // ignore: avoid_print
      print('│ Endpoint: ${error.endpoint}');
    }
    // ignore: avoid_print
    print('└─────────────────────────────────────────');
  }
}