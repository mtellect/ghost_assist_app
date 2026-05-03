import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import '../services/screen_capture_service.dart';
import 'mode_selector.dart';
import 'assistant_action_button.dart';
import 'status_bar.dart';

class AssistantFooter extends StatelessWidget {
  final ScreenCaptureService _captureService = ScreenCaptureService();

  AssistantFooter({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: AssistantActionButton(
                  icon: Icons.crop_free,
                  label: 'Smart Capture',
                  onTap: () async {
                    final file = await _captureService.captureRegion();
                    if (file != null && context.mounted) {
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
                child: AssistantActionButton(
                  icon: Icons.fullscreen,
                  label: 'Full Screen',
                  onTap: () async {
                    final file = await _captureService.captureScreen();
                    if (file != null && context.mounted) {
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white10),
          const SizedBox(height: 8),
          const StatusBar(),
        ],
      ),
    );
  }
}
