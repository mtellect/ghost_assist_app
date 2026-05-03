part of base_api;

class ApiUrls {
  static const String devBaseUrl = 'https://api-dev.ghostassist.ai/v1';
  static const String stagingBaseUrl = 'https://api-staging.ghostassist.ai/v1';
  static const String prodBaseUrl = 'https://api.ghostassist.ai/v1';

  static String getBaseUrl(ApiEnvironmentEnum env) {
    switch (env.key) {
      case EnvironmentKeys.staging:
        return stagingBaseUrl;
      case EnvironmentKeys.prod:
        return prodBaseUrl;
      default:
        return devBaseUrl;
    }
  }

  // Endpoints
  static const String login = '/auth/login';
  static const String analyze = '/ai/analyze';
}
