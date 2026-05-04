import 'package:flutter/material.dart';
import 'widgets/assistant_message_list.dart';
import 'widgets/assistant_footer.dart';

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
        AssistantFooter(),
      ],
    );
  }
}
