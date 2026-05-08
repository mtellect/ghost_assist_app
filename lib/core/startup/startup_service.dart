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
import '../../features/transcription/services/i_whisper_service.dart';
import '../../features/transcription/services/whisper_service.dart';
import '../../features/transcription/providers/transcription_provider.dart';
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
    // 1. Storage
    getIt.registerSingleton<IStorageService>(StorageService());

    // 2. Configuration
    getIt.registerLazySingleton<EnvConfigurationsModel>(() => EnvConfigurationsModel.instance);

    // 3. Platform Services
    getIt.registerLazySingleton<ScreenCaptureService>(() => ScreenCaptureService());
    getIt.registerLazySingleton<IAudioInterceptorService>(() => AudioInterceptorService());
    getIt.registerLazySingleton<HotKeyService>(() => HotKeyService());
    getIt.registerLazySingleton<PermissionService>(() => PermissionService());
    getIt.registerLazySingleton<IWhisperService>(() => WhisperService());

    // 4. AI Orchestrator (Registered as a lazy singleton, keys will be fetched during init)
    getIt.registerLazySingleton<IAssistantService>(() {
      final config = getIt<EnvConfigurationsModel>();

      // Note: These keys will be pulled from storage when the service is first accessed
      // In a real production app, we might update these dynamically
      return AssistantService(
        geminiApiKey: config.geminiApiKey,
        openaiApiKey: config.openaiApiKey,
        anthropicApiKey: config.anthropicApiKey,
        apiClient: getIt<ApiClient>(),
      );
    });
  }

  @override
  Future<void> registerControllers() async {
    // 1. Settings Provider
    getIt.registerLazySingleton<SettingsProvider>(() => SettingsProvider(getIt<IStorageService>()));

    // 2. Assistant Provider
    getIt.registerLazySingleton<AssistantProvider>(
      () => AssistantProvider(
        assistantService: getIt<IAssistantService>(),
        audioService: getIt<IAudioInterceptorService>(),
        captureService: getIt<ScreenCaptureService>(),
        transcriptionProvider: getIt<TranscriptionProvider>(),
      ),
    );

    // 3. Transcription Provider
    getIt.registerLazySingleton<TranscriptionProvider>(
      () => TranscriptionProvider(whisperService: getIt<IWhisperService>()),
    );
  }

  @override
  Future<void> initializeApp({required ApiEnvironmentEnum environment}) async {
    // Phase 1: Registration
    await registerNetwork();
    await registerServices(environment: environment);
    await registerControllers();

    // Phase 2: Sequential Initialization

    // 1. Storage first (dependency for almost everything)
    await getIt<IStorageService>().init();

    // 2. Settings (loads API keys and templates from storage)
    await getIt<SettingsProvider>().loadSettings();

    // 3. Permissions (Hardware access)
    await getIt<PermissionService>().checkAndRequestPermissions();

    // 4. Hotkeys (System events)
    await getIt<HotKeyService>().init();

    // 5. Whisper Model (Background load)
    getIt<IWhisperService>().ensureModelLoaded();
  }
}
