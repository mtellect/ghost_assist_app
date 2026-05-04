import 'package:flutter/material.dart';
import 'features/assistant/assistant_page.dart';
import 'features/settings/pages/settings_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isSettingsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: const Color(0xFF0A0A0B).withValues(alpha: 0.95),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _isSettingsOpen
                ? SettingsPage(onBack: () => setState(() => _isSettingsOpen = false))
                : AssistantPage(onSettingsOpen: () => setState(() => _isSettingsOpen = true)),
          ),
        ),
      ),
    );
  }
}
