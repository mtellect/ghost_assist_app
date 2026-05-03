import 'dart:io';
import '../models/assistant_mode.dart';

abstract class IAssistantService {
  /// Sends a prompt with optional image data to the AI model.
  Future<String> getResponse({
    required AssistantMode mode,
    required String prompt,
    File? screenCapture,
  });

  /// Provides context-specific instructions based on the interview mode.
  String getSystemPrompt(AssistantMode mode);

  /// Resets the current chat session and history.
  void resetChat();

  /// Switches between Pro and Flash models.
  void setUsePro(bool usePro);
}
