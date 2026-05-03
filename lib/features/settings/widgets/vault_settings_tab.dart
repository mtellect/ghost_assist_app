import 'package:flutter/material.dart';
import 'settings_key_field.dart';

class VaultSettingsTab extends StatelessWidget {
  final TextEditingController geminiController;
  final TextEditingController openaiController;
  final TextEditingController anthropicController;

  const VaultSettingsTab({
    super.key,
    required this.geminiController,
    required this.openaiController,
    required this.anthropicController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API CREDENTIALS',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SettingsKeyField(
            label: 'GOOGLE GEMINI',
            controller: geminiController,
            accentColor: Colors.blueAccent,
          ),
          const SizedBox(height: 20),
          SettingsKeyField(
            label: 'OPENAI GPT-4o',
            controller: openaiController,
            accentColor: Colors.greenAccent,
          ),
          const SizedBox(height: 20),
          SettingsKeyField(
            label: 'ANTHROPIC CLAUDE',
            controller: anthropicController,
            accentColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
