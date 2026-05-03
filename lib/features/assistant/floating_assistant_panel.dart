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
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 10,
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
    );
  }
}
