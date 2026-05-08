import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transcription_provider.dart';

class LiveCaptionView extends StatelessWidget {
  const LiveCaptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranscriptionProvider>();
    
    if (!provider.isTranscribing && provider.history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: provider.isTranscribing ? Colors.redAccent : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LIVE CAPTIONS',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: provider.currentTranscript.asMap().entries.map((entry) {
              final isLast = entry.key == provider.currentTranscript.length - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isLast ? 1.0 : 0.4),
                    fontSize: 14,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
