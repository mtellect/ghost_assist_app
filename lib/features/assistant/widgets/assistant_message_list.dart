import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';

class AssistantMessageList extends StatelessWidget {
  const AssistantMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    if (provider.response.isEmpty && !provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white10, size: 48),
            SizedBox(height: 16),
            Text(
              'READY TO ASSIST',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      children: [
        if (provider.response.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: MarkdownBody(
              data: provider.response,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 14,
                  height: 1.6,
                ),
                h1: const TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),
                h2: const TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold),
                h3: const TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
                listBullet: const TextStyle(color: Colors.blueAccent, fontSize: 14),
                blockquoteDecoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                  border: const Border(left: BorderSide(color: Colors.blueAccent, width: 4)),
                ),
                code: TextStyle(
                  color: Colors.greenAccent.withValues(alpha: 0.9),
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
                codeblockPadding: const EdgeInsets.all(16),
                codeblockDecoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
            ),
          ),
        if (provider.isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'THINKING...',
                  style: TextStyle(
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
