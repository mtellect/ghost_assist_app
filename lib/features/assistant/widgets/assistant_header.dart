import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/assistant_provider.dart';
import '../models/ai_model.dart';
import '../../settings/widgets/settings_dialog.dart';

class AssistantHeader extends StatelessWidget {
  const AssistantHeader({super.key});

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    return GestureDetector(
      onPanStart: (details) => windowManager.startDragging(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 12),
            const Text(
              '👻 GHOST ASSIST',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const Spacer(),

            // Audio Listening Toggle
            IconButton(
              icon: Icon(
                provider.isListening ? Icons.mic : Icons.mic_none,
                size: 18,
                color: provider.isListening ? Colors.redAccent : Colors.white60,
              ),
              onPressed: provider.toggleListening,
              tooltip: provider.isListening ? 'Stop Listening' : 'Start Listening',
            ),

            // Stealth Toggle
            IconButton(
              icon: Icon(
                provider.isStealth ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: provider.isStealth ? Colors.greenAccent : Colors.redAccent,
              ),
              onPressed: provider.toggleStealth,
              tooltip: 'Stealth Mode',
            ),

            // Model Selector
            PopupMenuButton<AIModel>(
              icon: Icon(
                _getModelIcon(provider.aiModel),
                size: 18,
                color: _getModelColor(provider.aiModel),
              ),
              onSelected: provider.setModel,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    enabled: false,
                    child: Text('GEMINI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ),
                  ...AIModel.values.where((m) => m.provider == AIProvider.gemini).map((model) => _buildMenuItem(model, provider)),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    enabled: false,
                    child: Text('OPENAI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  ),
                  ...AIModel.values.where((m) => m.provider == AIProvider.openai).map((model) => _buildMenuItem(model, provider)),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    enabled: false,
                    child: Text('ANTHROPIC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                  ),
                  ...AIModel.values.where((m) => m.provider == AIProvider.anthropic).map((model) => _buildMenuItem(model, provider)),
                ];
              },
              tooltip: 'Switch Model',
            ),

            IconButton(
              icon: const Icon(Icons.refresh, size: 18, color: Colors.white38),
              onPressed: provider.resetChat,
              tooltip: 'Reset Chat',
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 18, color: Colors.white38),
              onPressed: () => _showSettings(context),
              tooltip: 'Settings',
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.white38),
              onPressed: () => windowManager.close(),
              tooltip: 'Close App',
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<AIModel> _buildMenuItem(AIModel model, AssistantProvider provider) {
    return PopupMenuItem<AIModel>(
      value: model,
      child: Row(
        children: [
          Icon(_getModelIcon(model), size: 16, color: _getModelColor(model)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(model.description, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
            ],
          ),
          if (provider.aiModel == model) ...[
            const Spacer(),
            const Icon(Icons.check, size: 14, color: Colors.greenAccent),
          ],
        ],
      ),
    );
  }

  IconData _getModelIcon(AIModel model) {
    return model == AIModel.geminiPro || model == AIModel.gpt4o ? Icons.bolt : Icons.flash_on;
  }

  Color _getModelColor(AIModel model) {
    if (model.provider == AIProvider.openai) return Colors.greenAccent;
    if (model.provider == AIProvider.anthropic) return Colors.orangeAccent;
    return model == AIModel.geminiPro ? Colors.amberAccent : Colors.blueAccent;
  }
}
