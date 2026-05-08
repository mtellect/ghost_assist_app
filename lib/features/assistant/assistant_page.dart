import 'package:flutter/material.dart';
import 'widgets/assistant_message_list.dart';
import 'widgets/assistant_footer.dart';
import '../transcription/widgets/live_caption_view.dart';

class AssistantPage extends StatelessWidget {
  final VoidCallback onSettingsOpen;

  const AssistantPage({
    super.key,
    required this.onSettingsOpen,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: AssistantMessageList()),
        LiveCaptionView(), // NEW: Floating captions overlay
        AssistantFooter(),
      ],
    );
  }
}
