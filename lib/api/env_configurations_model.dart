part of 'base_api.dart';

class EnvConfigurationsModel {
  final ApiEnvironmentEnum envType;
  final String geminiApiKey;
  final String openaiApiKey;
  final String anthropicApiKey;
  final String flavor;
  final String baseUrl;

  const EnvConfigurationsModel._internal({
    required this.envType,
    required this.geminiApiKey,
    required this.openaiApiKey,
    required this.anthropicApiKey,
    required this.flavor,
    required this.baseUrl,
  });

  static const EnvConfigurationsModel _env = EnvConfigurationsModel._internal(
    envType: GhostAssistEnvironmentEnum.staging,
    geminiApiKey: String.fromEnvironment('GEMINI_API_KEY'),
    openaiApiKey: String.fromEnvironment('OPENAI_API_KEY'),
    anthropicApiKey: String.fromEnvironment('ANTHROPIC_API_KEY'),
    flavor: String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
    baseUrl: String.fromEnvironment('BASE_URL'),
  );

  factory EnvConfigurationsModel({
    required ApiEnvironmentEnum env,
  }) {
    return _env.copyWith(envType: env);
  }

  // Expose the singleton instance
  static EnvConfigurationsModel get instance => _env;

  EnvConfigurationsModel copyWith({
    ApiEnvironmentEnum? envType,
    String? geminiApiKey,
    String? openaiApiKey,
    String? anthropicApiKey,
    String? flavor,
    String? baseUrl,
  }) {
    return EnvConfigurationsModel._internal(
      envType: envType ?? this.envType,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      openaiApiKey: openaiApiKey ?? this.openaiApiKey,
      anthropicApiKey: anthropicApiKey ?? this.anthropicApiKey,
      flavor: flavor ?? this.flavor,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }
}
