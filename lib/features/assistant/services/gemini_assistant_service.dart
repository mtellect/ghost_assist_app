import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_model.dart';
import '../models/assistant_skill.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

class GeminiAssistantService implements IAssistantService {
  final String apiKey;
  late final Map<AIModel, GenerativeModel> _models;
  AIModel _currentModel = AIModel.geminiFlash;
  final List<Content> _history = [];

  GeminiAssistantService({required this.apiKey}) {
    _models = {
      AIModel.geminiPro: GenerativeModel(
        model: AIModel.geminiPro.id,
        apiKey: apiKey,
      ),
      AIModel.geminiFlash: GenerativeModel(
        model: AIModel.geminiFlash.id,
        apiKey: apiKey,
      ),
    };
  }

  @override
  void setModel(AIModel model) {
    _currentModel = model;
  }

  @override
  Future<String> getResponse({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async {
    try {
      final activeModel = _models[_currentModel]!;
      final List<Part> parts = [TextPart(prompt)];

      if (screenCapture != null) {
        final bytes = await screenCapture.readAsBytes();
        parts.add(DataPart('image/png', bytes));
      }

      if (audioFile != null) {
        final bytes = await audioFile.readAsBytes();
        parts.add(DataPart('audio/mp4', bytes));
      }

      final content = Content.multi(parts);
      final response = await activeModel.generateContent([content]);
      final text = response.text ?? 'No response.';

      _history.add(content);
      _history.add(Content.model([TextPart(text)]));

      return text;
    } catch (e) {
      GhostLogger.e('Gemini Error', tag: 'GeminiService', error: e);
      return 'Gemini Error: $e';
    }
  }

  @override
  void resetChat() {
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantSkill skill) => ''; // Handled by orchestrator
}
