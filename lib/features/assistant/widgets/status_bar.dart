import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import '../models/gemini_model.dart';

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
          provider.geminiModel == GeminiModel.proLatest ? Icons.bolt : Icons.flash_on,
          size: 10,
          color: provider.geminiModel == GeminiModel.proLatest ? Colors.amberAccent : Colors.blueAccent,
        ),
        const SizedBox(width: 4),
        Text(
          provider.geminiModel.label.toUpperCase(),
          style: const TextStyle(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.w600),
        ),
      ],
    );
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
