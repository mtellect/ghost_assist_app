part of '../base_api.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;

    switch (err.type) {
      case DioExceptionType.cancel:
        exception = ApiCancelledException(message: 'Request was cancelled');
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = ApiErrorException(message: 'Connection timed out', code: 408);
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? 'Received invalid status code: $statusCode';
        exception = UnsuccessfulApiStatusException(message: message, statusCode: statusCode);
        break;
      case DioExceptionType.connectionError:
        exception = ApiErrorException(message: 'No internet connection', code: 0);
        break;
      default:
        exception = ApiErrorException(message: 'An unexpected error occurred: ${err.message}');
    }

    // Return the custom exception wrapped in a DioException for the flow to continue
    handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
    ));
  }
}
