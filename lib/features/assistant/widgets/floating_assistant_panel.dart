import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ghost_assist_app/core/native/window_stealth.dart';
import 'package:ghost_assist_app/features/assistant/models/gemini_model.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/assistant_provider.dart';
import '../services/screen_capture_service.dart';
import 'mode_selector.dart';
import 'response_view.dart';

class FloatingAssistantPanel extends StatefulWidget {
  const FloatingAssistantPanel({super.key});

  @override
  State<FloatingAssistantPanel> createState() => _FloatingAssistantPanelState();
}

class _FloatingAssistantPanelState extends State<FloatingAssistantPanel> {
  final ScreenCaptureService _captureService = ScreenCaptureService();
  bool _isStealth = false; // Match initial state in app.dart

  void _toggleStealth() async {
    final newState = !_isStealth;
    await WindowStealth.setStealthMode(newState);
    setState(() {
      _isStealth = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                _buildHeader(),
                const Expanded(
                  child: ResponseView(),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            IconButton(
              icon: Icon(
                _isStealth ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: _isStealth ? Colors.greenAccent : Colors.redAccent,
              ),
              onPressed: _toggleStealth,
              tooltip: 'Stealth Mode',
            ),
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
              onPressed: () => context.read<AssistantProvider>().resetChat(),
              tooltip: 'Reset Session',
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.white38),
              onPressed: () => windowManager.close(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModeSelector(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.crop_free,
                  label: 'Smart Capture',
                  onTap: () async {
                    final file = await _captureService.captureRegion();
                    if (file != null && mounted) {
                      context.read<AssistantProvider>().ask(
                        'Analyze this screen content and provide help based on the current mode.',
                        screenCapture: file,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.fullscreen,
                  label: 'Full Screen',
                  onTap: () async {
                    final file = await _captureService.captureScreen();
                    if (file != null && mounted) {
                      context.read<AssistantProvider>().ask(
                        'Analyze the full screen.',
                        screenCapture: file,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
