import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'settings_key_field.dart';

class VaultSettingsTab extends StatelessWidget {
  const VaultSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SettingsProvider>();

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
            controller: provider.geminiController,
            accentColor: Colors.blueAccent,
          ),
          const SizedBox(height: 20),
          SettingsKeyField(
            label: 'OPENAI GPT-4o',
            controller: provider.openaiController,
            accentColor: Colors.greenAccent,
          ),
          const SizedBox(height: 20),
          SettingsKeyField(
            label: 'ANTHROPIC CLAUDE',
            controller: provider.anthropicController,
            accentColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
