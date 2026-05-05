import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as glass;
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/enums/api_environment_enum.dart';
import 'core/native/window_stealth.dart';
import 'core/startup/startup_service.dart';
import 'core/utils/logger.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'index_page.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'core/services/hotkey_service.dart';

Future<void> runApplication({required ApiEnvironmentEnum environment}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Startup Service
  final startupService = StartUpService();
  await startupService.initializeApp(environment: environment);

  // Initialize Window Manager
  await windowManager.ensureInitialized();
  await glass.Window.initialize();
  
  if (Platform.isWindows) {
    await glass.Window.setEffect(
      effect: glass.WindowEffect.acrylic,
      color: const Color(0x660A0A0B),
    );
  } else if (Platform.isMacOS) {
    await glass.Window.setEffect(
      effect: glass.WindowEffect.acrylic,
    );
  }

  GhostLogger.i('Initializing window...', tag: 'App');
  final bool isDebug = environment.key == EnvironmentKeys.staging;

  WindowOptions windowOptions = WindowOptions(
    size: const Size(600, 900),
    minimumSize: const Size(450, 700),
    maximumSize: const Size(600, 900),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true, // Hide from taskbar/dock for extra stealth
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(true);
    
    // macOS Specific: Ensure window follows to Full Screen spaces
    if (Platform.isMacOS) {
       // This allows the HUD to appear over full-screen apps and follow across Spaces
       await windowManager.setVisibleOnAllWorkspaces(true, visibleOnFullScreen: true);
    }

    GhostLogger.i('Window ready and shown.', tag: 'App');
    await windowManager.setAlwaysOnTop(true);
  });

  // Enable Stealth Mode by default
  await WindowStealth.setStealthMode(true);
  await windowManager.setIgnoreMouseEvents(false);
  await windowManager.setAlwaysOnTop(true);
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

  // Option + C: Toggle Click-Through
  await hotKeyService.registerHotKey(
    keyCode: PhysicalKeyboardKey.keyC,
    modifiers: [HotKeyModifier.alt],
    identifier: 'toggle_click_through',
    onPressed: () => assistantProvider.toggleClickThrough(),
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
      home: const IndexPage(),
    );
  }
}
