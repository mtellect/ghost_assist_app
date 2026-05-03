import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/enums/api_environment_enum.dart';
import 'core/native/window_stealth.dart';
import 'core/startup/startup_service.dart';
import 'core/utils/logger.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/assistant/floating_assistant_panel.dart';

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
  await WindowStealth.setStealthMode(false);

  GhostLogger.i('Starting runApp...', tag: 'App');
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: getIt<AssistantProvider>())],
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
