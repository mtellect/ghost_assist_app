import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as glass;
import 'features/assistant/assistant_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'widgets/ghost_header.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isSettingsOpen = false;
  bool _isCollapsed = false;

  Future<void> _toggleCollapse() async {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });

    if (_isCollapsed) {
      await windowManager.setResizable(false);
      await windowManager.setSize(const Size(180, 45));
      await glass.Window.setEffect(effect: glass.WindowEffect.transparent);
    } else {
      await windowManager.setResizable(true);
      await windowManager.setSize(const Size(600, 900));
      await windowManager.center();

      // Restore glass effect based on platform
      if (Platform.isWindows) {
        await glass.Window.setEffect(
          effect: glass.WindowEffect.acrylic,
          color: const Color(0x660A0A0B),
        );
      } else if (Platform.isMacOS) {
        await glass.Window.setEffect(effect: glass.WindowEffect.acrylic);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main Glass Window
          if (!_isCollapsed)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0B).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        GhostHeader(
                          isSettings: _isSettingsOpen,
                          onSettingsToggle: () => setState(() => _isSettingsOpen = true),
                          onBack: () => setState(() => _isSettingsOpen = false),
                          isCollapsed: _isCollapsed,
                          onCollapseToggle: _toggleCollapse,
                        ),
                        Expanded(
                          child: _isSettingsOpen
                              ? SettingsPage(onBack: () => setState(() => _isSettingsOpen = false))
                              : AssistantPage(
                                  onSettingsOpen: () => setState(() => _isSettingsOpen = true),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Collapsed Pill Bar (Re-using Header logic)
          if (_isCollapsed)
            Align(
              alignment: Alignment.topCenter,
              child: GhostHeader(
                isSettings: _isSettingsOpen,
                onSettingsToggle: () {},
                isCollapsed: true,
                onCollapseToggle: _toggleCollapse,
              ),
            ),
        ],
      ),
    );
  }
}
