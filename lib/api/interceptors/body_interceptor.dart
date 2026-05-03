part of base_api;

class BodyInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Optional: Log or modify the response body here
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Optional: Log or modify the request body here
    super.onRequest(options, handler);
  }
}
