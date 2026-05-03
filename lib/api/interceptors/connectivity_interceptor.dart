part of base_api;

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final bool hasConnection = await InternetConnection().hasInternetAccess;
    
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
