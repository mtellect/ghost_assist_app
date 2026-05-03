part of '../base_api.dart';

class ApiErrorException implements Exception {
  final String? message;
  final int? code;

  ApiErrorException({this.message, this.code});

  @override
  String toString() => message ?? 'An unknown API error occurred';
}
