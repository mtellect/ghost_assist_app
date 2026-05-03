import 'dart:ui';
import 'package:flutter/material.dart';
import 'widgets/assistant_header.dart';
import 'widgets/assistant_message_list.dart';
import 'widgets/assistant_footer.dart';

class FloatingAssistantPanel extends StatelessWidget {
  const FloatingAssistantPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E1E2E).withValues(alpha: 0.9),
                  const Color(0xFF121212).withValues(alpha: 0.85),
                ],
                stops: const [0.0, 1.0],
              ),
              boxShadow: [
                // Deep ambient shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                // Subtle outer glow
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const AssistantHeader(),
                const AssistantMessageList(),
                AssistantFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
