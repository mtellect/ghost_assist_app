import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';

class AssistantMessageList extends StatelessWidget {
  const AssistantMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    if (provider.response.isEmpty && !provider.isLoading && provider.error == null) {
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
        if (provider.error != null)
          _buildErrorCard(context, provider),
        if (provider.response.isNotEmpty)
          _buildMessageCard(context, provider),
        if (provider.isLoading)
          _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, AssistantProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
              const SizedBox(width: 12),
              const Text(
                'AI SERVICE ERROR',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.white38),
                onPressed: provider.clearError,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            provider.error!,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
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
    );
  }

  Widget _buildMessageCard(BuildContext context, AssistantProvider provider) {
    return Container(
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
    );
  }
}
