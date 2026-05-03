import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import 'mode_selector.dart';
import 'assistant_action_button.dart';
import 'status_bar.dart';

class AssistantFooter extends StatelessWidget {
  const AssistantFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AssistantProvider>();
    
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
                  onTap: provider.captureRegion,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AssistantActionButton(
                  icon: Icons.fullscreen,
                  label: 'Full Screen',
                  onTap: provider.captureFullScreen,
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
