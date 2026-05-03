part of base_api;

enum Environment { dev, staging, prod }

class EnvConfigurationsModel {
  final Environment environment;
  final String baseUrl;

  EnvConfigurationsModel({
    required this.environment,
    required this.baseUrl,
  });
}
