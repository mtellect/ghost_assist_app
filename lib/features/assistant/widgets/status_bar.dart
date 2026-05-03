import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import '../models/ai_model.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    
    return Row(
      children: [
        _buildStatusDot(provider.isStealth ? Colors.greenAccent : Colors.redAccent),
        const SizedBox(width: 6),
        Text(
          provider.isStealth ? 'STEALTH ACTIVE' : 'STEALTH OFF (VISIBLE)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: provider.isStealth ? Colors.greenAccent : Colors.redAccent,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        if (provider.isListening) ...[
          _buildStatusDot(Colors.redAccent),
          const SizedBox(width: 6),
          const Text(
            'LISTENING',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Icon(
          _getModelIcon(provider.aiModel),
          size: 10,
          color: _getModelColor(provider.aiModel),
        ),
        const SizedBox(width: 4),
        Text(
          provider.aiModel.label.toUpperCase(),
          style: const TextStyle(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  IconData _getModelIcon(AIModel model) {
    return model == AIModel.geminiPro || model == AIModel.gpt4o ? Icons.bolt : Icons.flash_on;
  }

  Color _getModelColor(AIModel model) {
    if (model.provider == AIProvider.openai) return Colors.greenAccent;
    return model == AIModel.geminiPro ? Colors.amberAccent : Colors.blueAccent;
  }

  Widget _buildStatusDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
