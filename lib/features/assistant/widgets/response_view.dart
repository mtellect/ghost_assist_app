import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';

class ResponseView extends StatelessWidget {
  const ResponseView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 16),
            Text(
              'Thinking...',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (provider.response.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 48, color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),
            const Text(
              'Ready to assist you.',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const Text(
              'Capture a question to begin.',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Markdown(
      data: provider.response,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
        h1: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        h2: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        code: TextStyle(
          backgroundColor: Colors.white.withOpacity(0.05),
          color: Colors.greenAccent,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
      ),
    );
  }
}
