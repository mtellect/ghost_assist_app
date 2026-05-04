import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_model.dart';
import '../models/assistant_skill.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

class GeminiAssistantService implements IAssistantService {
  String _apiKey;
  Map<AIModel, GenerativeModel> _models = {};
  AIModel _currentModel = AIModel.geminiFlash;
  final List<Content> _history = [];

  GeminiAssistantService({required String apiKey}) : _apiKey = apiKey {
    _initModels();
  }

  void _initModels() {
    if (_apiKey.isEmpty) {
      GhostLogger.w('Gemini API Key is empty. Service will fail until key is provided.', tag: 'GeminiService');
      return;
    }
    
    _models = {
      AIModel.geminiPro: GenerativeModel(
        model: AIModel.geminiPro.id,
        apiKey: _apiKey,
      ),
      AIModel.geminiFlash: GenerativeModel(
        model: AIModel.geminiFlash.id,
        apiKey: _apiKey,
      ),
    };
  }

  void updateApiKey(String newKey) {
    if (_apiKey == newKey) return;
    _apiKey = newKey;
    _initModels();
    GhostLogger.i('Gemini API Key updated.', tag: 'GeminiService');
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
      if (_apiKey.isEmpty) {
        return 'Error: Gemini API Key is missing. Please set it in Settings.';
      }

      final activeModel = _models[_currentModel];
      if (activeModel == null) {
        return 'Error: Gemini model not initialized. Check your API key.';
      }

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
  Stream<String> getResponseStream({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async* {
    // Gemini streaming to be implemented
    final response = await getResponse(
      skill: skill,
      prompt: prompt,
      screenCapture: screenCapture,
      audioFile: audioFile,
    );
    yield response;
  }

  @override
  void resetChat() {
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantSkill skill) => ''; // Handled by orchestrator
}
