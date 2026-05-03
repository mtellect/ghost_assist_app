import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _geminiController;
  late final TextEditingController _openaiController;
  late final TextEditingController _anthropicController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SettingsProvider>();
    _geminiController = TextEditingController(text: provider.geminiKey);
    _openaiController = TextEditingController(text: provider.openaiKey);
    _anthropicController = TextEditingController(text: provider.anthropicKey);
  }

  @override
  void dispose() {
    _geminiController.dispose();
    _openaiController.dispose();
    _anthropicController.dispose();
    super.dispose();
  }

  Future<void> _save(SettingsProvider provider) async {
    await provider.saveKeys(
      gemini: _geminiController.text,
      openai: _openaiController.text,
      anthropic: _anthropicController.text,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vault updated. Restart required to apply changes.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: provider.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VAULT SETTINGS',
                  style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 24),
                _buildKeyField('GEMINI API KEY', _geminiController, Colors.blueAccent),
                const SizedBox(height: 16),
                _buildKeyField('OPENAI API KEY', _openaiController, Colors.greenAccent),
                const SizedBox(height: 16),
                _buildKeyField('ANTHROPIC API KEY', _anthropicController, Colors.orangeAccent),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('CANCEL', style: TextStyle(color: Colors.white38)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _save(provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('SAVE TO VAULT'),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildKeyField(String label, TextEditingController controller, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: accentColor.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            hintText: 'Paste key here...',
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
