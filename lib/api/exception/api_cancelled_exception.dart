part of '../base_api.dart';

class ApiCancelledException implements Exception {
  final String? message;

  ApiCancelledException({this.message});

  @override
  String toString() => message ?? 'API request was cancelled';
}
