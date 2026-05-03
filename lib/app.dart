import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/enums/api_environment_enum.dart';
import 'core/native/window_stealth.dart';
import 'core/startup/startup_service.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/assistant/widgets/floating_assistant_panel.dart';

Future<void> runApplication({required ApiEnvironmentEnum environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Startup Service
  final startupService = StartUpService();
  await startupService.initializeApp(environment: environment);

  // Initialize Window Manager
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 600),
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
  });

  // Enable Stealth Mode by default
  await WindowStealth.setStealthMode(true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: getIt<AssistantProvider>(),
        ),
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
