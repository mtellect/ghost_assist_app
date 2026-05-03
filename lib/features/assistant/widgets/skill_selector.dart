import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assistant_skill.dart';
import '../providers/assistant_provider.dart';

class SkillSelector extends StatelessWidget {
  const SkillSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: AssistantSkill.values.map((skill) {
        final isSelected = provider.skill == skill;
        return ChoiceChip(
          label: Text(skill.displayName),
          selected: isSelected,
          onSelected: (_) => provider.setSkill(skill),
          selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          labelStyle: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}
