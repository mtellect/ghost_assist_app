part of base_api;

class EnvConfigurationsModel {
  final ApiEnvironmentEnum environment;
  final String baseUrl;

  EnvConfigurationsModel({
    required this.environment,
    required this.baseUrl,
  });
}
