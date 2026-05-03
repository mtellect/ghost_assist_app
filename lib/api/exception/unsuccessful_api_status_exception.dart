part of base_api;

class UnsuccessfulApiStatusException implements Exception {
  final String? message;
  final int? statusCode;

  UnsuccessfulApiStatusException({this.message, this.statusCode});

  @override
  String toString() => message ?? 'API returned an unsuccessful status: $statusCode';
}
