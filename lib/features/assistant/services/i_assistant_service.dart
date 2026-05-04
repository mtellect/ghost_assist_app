import 'dart:io';
import 'package:ghost_assist_app/features/assistant/models/ai_model.dart';
import '../models/assistant_skill.dart';

abstract class IAssistantService {
  /// Sends a prompt with optional image data to the AI model.
  Future<String> getResponse({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  });

  /// Streams the response from the AI model for real-time feedback.
  Stream<String> getResponseStream({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  });

  /// Provides context-specific instructions based on the interview skill.
  String getSystemPrompt(AssistantSkill skill);

  /// Resets the current chat session and history.
  void resetChat();

  /// Switches between different AI models.
  void setModel(AIModel model);
}
