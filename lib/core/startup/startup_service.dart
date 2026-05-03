import 'package:get_it/get_it.dart';
import '../../api/base_api.dart';
import '../../features/assistant/services/assistant_service.dart';
import '../../features/assistant/services/i_assistant_service.dart';
import '../../features/assistant/providers/assistant_provider.dart';
import '../../features/assistant/services/screen_capture_service.dart';
import '../../features/assistant/services/i_audio_interceptor_service.dart';
import '../../features/assistant/services/audio_interceptor_service.dart';
import '../services/hotkey_service.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';
import '../../features/settings/providers/settings_provider.dart';
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
    // 1. Initialize Storage
    final storage = StorageService();
    await storage.init();
    getIt.registerSingleton<IStorageService>(storage);

    final config = EnvConfigurationsModel.instance;
    getIt.registerLazySingleton<EnvConfigurationsModel>(() => config);

    // 2. Fetch Keys with Fallback
    final savedGeminiKey = await storage.getSecureKey('GEMINI_API_KEY');
    final savedOpenAiKey = await storage.getSecureKey('OPENAI_API_KEY');
    final savedAnthropicKey = await storage.getSecureKey('ANTHROPIC_API_KEY');

    final geminiKey = (savedGeminiKey != null && savedGeminiKey.isNotEmpty)
        ? savedGeminiKey
        : config.geminiApiKey;

    final openaiKey = (savedOpenAiKey != null && savedOpenAiKey.isNotEmpty)
        ? savedOpenAiKey
        : config.openaiApiKey;

    final anthropicKey = (savedAnthropicKey != null && savedAnthropicKey.isNotEmpty)
        ? savedAnthropicKey
        : config.anthropicApiKey;

    // 3. Register AI Services
    getIt.registerLazySingleton<IAssistantService>(
      () => AssistantService(
        geminiApiKey: geminiKey,
        openaiApiKey: openaiKey,
        anthropicApiKey: anthropicKey,
      ),
    );

    getIt.registerLazySingleton<ScreenCaptureService>(() => ScreenCaptureService());

    getIt.registerLazySingleton<IAudioInterceptorService>(() => AudioInterceptorService());

    getIt.registerLazySingleton<HotKeyService>(() => HotKeyService());
    
    getIt.registerLazySingleton<PermissionService>(() => PermissionService());
  }

  @override
  Future<void> registerControllers() async {
    // 1. Register Settings Controller (Provider)
    final settingsProvider = SettingsProvider(getIt<IStorageService>());
    await settingsProvider.loadSettings();
    getIt.registerSingleton<SettingsProvider>(settingsProvider);

    // 2. Register Assistant Controller (Provider)
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

    // Trigger permission check on startup
    final permissionService = getIt<PermissionService>();
    await permissionService.checkAndRequestPermissions();
  }
}
