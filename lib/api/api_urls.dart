part of base_api;

class ApiUrls {
  static const String devBaseUrl = 'https://api-dev.ghostassist.ai/v1';
  static const String stagingBaseUrl = 'https://api-staging.ghostassist.ai/v1';
  static const String prodBaseUrl = 'https://api.ghostassist.ai/v1';

  static String getBaseUrl(Environment env) {
    switch (env) {
      case Environment.dev:
        return devBaseUrl;
      case Environment.staging:
        return stagingBaseUrl;
      case Environment.prod:
        return prodBaseUrl;
    }
  }

  // Endpoints
  static const String login = '/auth/login';
  static const String analyze = '/ai/analyze';
}
