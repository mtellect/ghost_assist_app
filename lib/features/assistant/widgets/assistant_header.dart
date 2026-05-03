import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/assistant_provider.dart';
import '../models/gemini_model.dart';

class AssistantHeader extends StatelessWidget {
  const AssistantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    
    return GestureDetector(
      onPanStart: (details) => windowManager.startDragging(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 12),
            const Text(
              'GHOST ASSIST',
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
            PopupMenuButton<GeminiModel>(
              icon: Icon(
                provider.geminiModel == GeminiModel.proLatest ? Icons.bolt : Icons.flash_on,
                size: 18,
                color: provider.geminiModel == GeminiModel.proLatest ? Colors.amberAccent : Colors.blueAccent,
              ),
              onSelected: provider.setModel,
              itemBuilder: (context) => GeminiModel.values.map((model) {
                return PopupMenuItem<GeminiModel>(
                  value: model,
                  child: Row(
                    children: [
                      Icon(
                        model == GeminiModel.proLatest ? Icons.bolt : Icons.flash_on,
                        size: 16,
                        color: model == GeminiModel.proLatest ? Colors.amberAccent : Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(model.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text(model.description, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                      if (provider.geminiModel == model) ...[
                        const Spacer(),
                        const Icon(Icons.check, size: 14, color: Colors.greenAccent),
                      ],
                    ],
                  ),
                );
              }).toList(),
              tooltip: 'Switch Model',
            ),
            
            IconButton(
              icon: const Icon(Icons.refresh, size: 18, color: Colors.white38),
              onPressed: provider.resetChat,
              tooltip: 'Reset Chat',
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
}
