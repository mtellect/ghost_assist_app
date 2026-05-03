import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/native/window_stealth.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/assistant/services/assistant_service.dart';
import 'features/assistant/widgets/floating_assistant_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

  // Replace with actual API Key or handle via settings
  const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AssistantProvider(AssistantService(apiKey: geminiApiKey)),
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
