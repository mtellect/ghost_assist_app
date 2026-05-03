import 'package:flutter/material.dart';

class PromptSettingsTab extends StatelessWidget {
  final TextEditingController templateController;

  const PromptSettingsTab({
    super.key,
    required this.templateController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JSON SKILL TEMPLATES',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: templateController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                hintText: '{ "skill_name": "Prompt instruction..." }',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
