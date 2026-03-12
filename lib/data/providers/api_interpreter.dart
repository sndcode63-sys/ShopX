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
    print('┌──────────── API REQUEST ────────────────');
    print('│ → ${request.path}');
    if (request.queryParams?.isNotEmpty == true) {
      print('│ Params: ${request.queryParams}');
    }
    print('└─────────────────────────────────────────');
  }

  @override
  void onResponse(ApiResponse response) {
    print('┌──────────── API RESPONSE ───────────────');
    print('│ ✅ Status: ${response.statusCode}');
    print('│ ⏱ Duration: ${response.duration.inMilliseconds}ms');
    print('└─────────────────────────────────────────');
  }

  @override
  void onError(ApiException error) {
    print('┌──────────── API ERROR ──────────────────');
    print('│ ❌ $error');
    if (error.endpoint != null) {
      print('│ Endpoint: ${error.endpoint}');
    }
    print('└─────────────────────────────────────────');
  }
}