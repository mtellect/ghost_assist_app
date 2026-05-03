part of base_api;

class NoContentException implements Exception {
  final String? message;

  NoContentException({this.message});

  @override
  String toString() => message ?? 'API returned no content';
}
