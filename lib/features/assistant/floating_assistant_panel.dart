import 'package:flutter/material.dart';
import 'widgets/assistant_header.dart';
import 'widgets/assistant_message_list.dart';
import 'widgets/assistant_footer.dart';
import '../settings/pages/settings_page.dart';

class FloatingAssistantPanel extends StatefulWidget {
  const FloatingAssistantPanel({super.key});

  @override
  State<FloatingAssistantPanel> createState() => _FloatingAssistantPanelState();
}

class _FloatingAssistantPanelState extends State<FloatingAssistantPanel> {
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
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
              : Column(
                  children: [
                    AssistantHeader(onSettingsToggle: () => setState(() => _isSettingsOpen = true)),
                    const Expanded(child: AssistantMessageList()),
                    const AssistantFooter(),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
