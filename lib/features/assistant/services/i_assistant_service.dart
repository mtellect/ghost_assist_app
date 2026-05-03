import 'dart:io';
import 'package:ghost_assist_app/features/assistant/models/ai_model.dart';

import '../models/assistant_mode.dart';

abstract class IAssistantService {
  /// Sends a prompt with optional image data to the AI model.
  Future<String> getResponse({
    required AssistantMode mode,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  });

  /// Provides context-specific instructions based on the interview mode.
  String getSystemPrompt(AssistantMode mode);

  /// Resets the current chat session and history.
  void resetChat();

  /// Switches between different AI models.
  void setModel(AIModel model);
}
