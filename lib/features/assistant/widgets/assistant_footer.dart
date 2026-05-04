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
          // Expert Actions (Cluely Style)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExpertAction(
                  'Assist',
                  Icons.auto_awesome,
                  Colors.blueAccent,
                  () {}, // Standard chat
                ),
                _buildExpertAction(
                  'What should I say?',
                  Icons.chat_bubble_outline,
                  Colors.white70,
                  () => provider.smartAsk('Based on the conversation and current screen state, what is the most effective thing for me to say next to impress the interviewer?'),
                ),
                _buildExpertAction(
                  'Follow-ups',
                  Icons.question_answer_outlined,
                  Colors.white70,
                  () => provider.smartAsk('What are 3 strategic follow-up questions I could ask right now to show deep technical curiosity or leadership?'),
                ),
                _buildExpertAction(
                  'Recap',
                  Icons.history,
                  Colors.white70,
                  () => provider.smartAsk('Provide a concise bulleted recap of the conversation so far, focusing on key technical points and my contributions.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

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
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Type a question...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.send_rounded, size: 18, color: Colors.blueAccent),
                  onPressed: provider.sendTextQuery,
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

  Widget _buildExpertAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color.withValues(alpha: 0.6)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
