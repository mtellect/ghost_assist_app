import 'package:flutter/material.dart';
import '../../assistant/models/assistant_skill.dart';

class PromptSettingsTab extends StatefulWidget {
  final Map<AssistantSkill, TextEditingController> skillControllers;

  const PromptSettingsTab({
    super.key,
    required this.skillControllers,
  });

  @override
  State<PromptSettingsTab> createState() => _PromptSettingsTabState();
}

class _PromptSettingsTabState extends State<PromptSettingsTab> {
  AssistantSkill _selectedSkill = AssistantSkill.flutter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Rail: Skill List
        Container(
          width: 180,
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Colors.white10)),
          ),
          child: ListView.builder(
            itemCount: AssistantSkill.values.length,
            itemBuilder: (context, index) {
              final skill = AssistantSkill.values[index];
              final isSelected = _selectedSkill == skill;
              return InkWell(
                onTap: () => setState(() => _selectedSkill = skill),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: isSelected ? Colors.blueAccent.withValues(alpha: 0.1) : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 14,
                        color: isSelected ? Colors.blueAccent : Colors.white24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          skill.displayName.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white24,
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Right Pane: Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SYSTEM INSTRUCTIONS',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedSkill.displayName,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.info_outline, color: Colors.white10, size: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: widget.skillControllers[_selectedSkill],
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.2),
                      hintText: 'Define the identity and context for this skill...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.05),
                        fontStyle: FontStyle.italic,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This prompt will be injected as the system instruction when this skill is active.',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
