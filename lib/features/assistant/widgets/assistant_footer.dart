import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import 'skill_selector.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Input Field
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: TextField(
              controller: provider.textController,
              maxLines: null,
              minLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                hintText: 'Type a question...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 12),
                contentPadding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                border: InputBorder.none,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, size: 18, color: Colors.blueAccent),
                    onPressed: provider.sendTextQuery,
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'SELECT INTERVIEW SKILL',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const SkillSelector(),
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
