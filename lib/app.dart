import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/enums/api_environment_enum.dart';
import 'core/native/window_stealth.dart';
import 'core/startup/startup_service.dart';
import 'core/utils/logger.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/assistant/floating_assistant_panel.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'core/services/hotkey_service.dart';

Future<void> runApplication({required ApiEnvironmentEnum environment}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Startup Service
  final startupService = StartUpService();
  await startupService.initializeApp(environment: environment);

  // Initialize Window Manager
  await windowManager.ensureInitialized();

  GhostLogger.i('Initializing window...', tag: 'App');
  final bool isDebug = environment.key == EnvironmentKeys.staging;

  WindowOptions windowOptions = WindowOptions(
    size: const Size(600, 900),
    minimumSize: const Size(450, 700),
    maximumSize: const Size(600, 900),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(true);
    GhostLogger.i('Window ready and shown.', tag: 'App');
  });

  // Enable Stealth Mode by default
  await WindowStealth.setStealthMode(true);
  await windowManager.setIgnoreMouseEvents(false);
  await windowManager.setOpacity(1.0);

  // Initialize HotKeys
  final assistantProvider = getIt<AssistantProvider>();
  final hotKeyService = getIt<HotKeyService>();
  await hotKeyService.init();

  // Option + S: Smart Capture
  await hotKeyService.registerHotKey(
    keyCode: PhysicalKeyboardKey.keyS,
    modifiers: [HotKeyModifier.alt],
    identifier: 'smart_capture',
    onPressed: () => assistantProvider.captureRegion(),
  );

  // Option + F: Full Screen
  await hotKeyService.registerHotKey(
    keyCode: PhysicalKeyboardKey.keyF,
    modifiers: [HotKeyModifier.alt],
    identifier: 'full_screen',
    onPressed: () => assistantProvider.captureFullScreen(),
  );

  // Option + L: Toggle Listening
  await hotKeyService.registerHotKey(
    keyCode: PhysicalKeyboardKey.keyL,
    modifiers: [HotKeyModifier.alt],
    identifier: 'toggle_listening',
    onPressed: () => assistantProvider.toggleListening(),
  );

  // Option + H: Toggle Stealth
  await hotKeyService.registerHotKey(
    keyCode: PhysicalKeyboardKey.keyH,
    modifiers: [HotKeyModifier.alt],
    identifier: 'toggle_stealth',
    onPressed: () => assistantProvider.toggleStealth(),
  );

  GhostLogger.i('Starting runApp...', tag: 'App');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AssistantProvider>()),
        ChangeNotifierProvider.value(value: getIt<SettingsProvider>()),
      ],
      child: const GhostAssistApp(),
    ),
  );
}

class GhostAssistApp extends StatelessWidget {
  const GhostAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghost Assist',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const FloatingAssistantPanel(),
    );
  }
}
