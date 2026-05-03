part of 'base_api.dart';

class EnvConfigurationsModel {
  final ApiEnvironmentEnum environment;
  final String baseUrl;

  EnvConfigurationsModel({
    required this.environment,
    required this.baseUrl,
  });
}
