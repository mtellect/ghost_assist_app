import 'package:get_it/get_it.dart';
import '../../api/base_api.dart';
import '../../features/assistant/services/assistant_service.dart';
import '../../features/assistant/services/i_assistant_service.dart';
import '../../features/assistant/providers/assistant_provider.dart';
import '../../features/assistant/services/screen_capture_service.dart';
import '../../features/assistant/services/i_audio_interceptor_service.dart';
import '../../features/assistant/services/audio_interceptor_service.dart';
import '../services/hotkey_service.dart';
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
    final config = EnvConfigurationsModel.instance;
    
    getIt.registerLazySingleton<EnvConfigurationsModel>(() => config);
    
    // Set base URL in ApiClient
    getIt<ApiClient>().updateBaseUrl(config.baseUrl);

    getIt.registerLazySingleton<IAssistantService>(
      () => AssistantService(
        geminiApiKey: config.geminiApiKey,
        openaiApiKey: config.openaiApiKey,
      ),
    );

    getIt.registerLazySingleton<ScreenCaptureService>(() => ScreenCaptureService());

    getIt.registerLazySingleton<IAudioInterceptorService>(() => AudioInterceptorService());

    getIt.registerLazySingleton<HotKeyService>(() => HotKeyService());
  }

  @override
  Future<void> registerControllers() async {
    getIt.registerLazySingleton<AssistantProvider>(
      () => AssistantProvider(
        assistantService: getIt<IAssistantService>(),
        audioService: getIt<IAudioInterceptorService>(),
        captureService: getIt<ScreenCaptureService>(),
      ),
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
