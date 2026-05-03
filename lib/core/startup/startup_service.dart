import 'package:get_it/get_it.dart';
import '../../api/base_api.dart';
import '../../features/assistant/services/assistant_service.dart';
import '../../features/assistant/services/i_assistant_service.dart';
import '../../features/assistant/providers/assistant_provider.dart';
import '../../features/assistant/services/screen_capture_service.dart';
import 'i_startup_service.dart';

import '../enums/api_environment_enum.dart';

final getIt = GetIt.instance;

class StartUpService implements IStartUpService {
  @override
  Future<void> registerNetwork() async {
    getIt.registerLazySingleton<ApiClient>(() => ApiClient.init());
  }

  @override
  Future<void> registerServices({required ApiEnvironmentEnum environment}) async {
    final String geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY');
    
    getIt.registerLazySingleton<EnvConfigurationsModel>(
      () => EnvConfigurationsModel(
        environment: environment,
        baseUrl: ApiUrls.getBaseUrl(environment),
      ),
    );
    
    // Set base URL in ApiClient
    getIt<ApiClient>().updateBaseUrl(ApiUrls.getBaseUrl(environment));

    getIt.registerLazySingleton<IAssistantService>(
      () => AssistantService(apiKey: geminiApiKey),
    );

    getIt.registerLazySingleton<ScreenCaptureService>(
      () => ScreenCaptureService(),
    );
  }

  @override
  Future<void> registerControllers() async {
    getIt.registerLazySingleton<AssistantProvider>(
      () => AssistantProvider(getIt<IAssistantService>()),
    );
  }

  @override
  Future<void> initializeApp({required ApiEnvironmentEnum environment}) async {
    await registerNetwork();
    await registerServices(environment: environment);
    await registerControllers();
    
    // Additional initializations (e.g., local DB) would go here
  }
}
