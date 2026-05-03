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
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 16),
              const Text(
                'How can I help you today?',
                style: TextStyle(color: Colors.white38),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (provider.response.isNotEmpty)
            MarkdownBody(
              data: provider.response,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                code: TextStyle(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          if (provider.isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                      'Thinking...',
                      style: TextStyle(
                        color: Colors.blueAccent.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
