part of base_api;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.getBaseUrl(Environment.dev), // Default to dev
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      HeadersInterceptor(),
      AuthenticationInterceptor(),
      BodyInterceptor(),
      ErrorInterceptor(),
      ChuckerDioInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }
}
