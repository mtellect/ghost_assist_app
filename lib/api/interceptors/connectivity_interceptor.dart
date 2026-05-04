part of '../base_api.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    bool hasConnection = true;
    try {
      // Use a shorter timeout for the check to avoid hanging
      hasConnection = await InternetConnection().hasInternetAccess;
    } catch (e) {
      // If the check fails (common in MSIX sandbox), assume we have connection
      // and let the actual request handle the failure.
      GhostLogger.w('Connectivity check failed: $e. Defaulting to true.', tag: 'ConnectivityInterceptor');
      hasConnection = true;
    }
    
    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: ApiErrorException(message: 'No internet connection available'),
          type: DioExceptionType.connectionError,
        ),
      );
    }
    
    return super.onRequest(options, handler);
  }
}
