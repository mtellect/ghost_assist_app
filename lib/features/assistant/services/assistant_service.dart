import 'dart:io';
import '../models/ai_model.dart';
import '../models/assistant_mode.dart';
import 'i_assistant_service.dart';
import 'gemini_assistant_service.dart';
import 'openai_assistant_service.dart';
import 'claude_assistant_service.dart';
import '../../../core/utils/logger.dart';

class AssistantService implements IAssistantService {
  final GeminiAssistantService _geminiService;
  final OpenAiAssistantService _openaiService;
  final ClaudeAssistantService _claudeService;
  
  AIModel _currentModel = AIModel.defaultModel;

  AssistantService({
    required String geminiApiKey,
    required String openaiApiKey,
    required String anthropicApiKey,
  })  : _geminiService = GeminiAssistantService(apiKey: geminiApiKey),
        _openaiService = OpenAiAssistantService(apiKey: openaiApiKey),
        _claudeService = ClaudeAssistantService(apiKey: anthropicApiKey);

  @override
  void setModel(AIModel model) {
    _currentModel = model;
    _geminiService.setModel(model);
    _openaiService.setModel(model);
    _claudeService.setModel(model);
  }

  @override
  Future<String> getResponse({
    required AssistantMode mode,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async {
    final systemPrompt = getSystemPrompt(mode);
    final fullPrompt = '$systemPrompt\n\n$prompt';

    GhostLogger.d('Routing request to ${_currentModel.provider.name}...', tag: 'AssistantService');

    if (_currentModel.provider == AIProvider.gemini) {
      return _geminiService.getResponse(
        mode: mode,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    } else if (_currentModel.provider == AIProvider.openai) {
      return _openaiService.getResponse(
        mode: mode,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    } else {
      return _claudeService.getResponse(
        mode: mode,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    }
  }

  @override
  void resetChat() {
    _geminiService.resetChat();
    _openaiService.resetChat();
    _claudeService.resetChat();
  }

  @override
  String getSystemPrompt(AssistantMode mode) {
    switch (mode) {
      case AssistantMode.flutter:
        return 'You are a Senior Flutter Developer and Architect...';
      case AssistantMode.ios:
        return 'You are a Senior iOS Engineer...';
      case AssistantMode.android:
        return 'You are a Senior Android Engineer...';
      case AssistantMode.springboot:
        return 'You are a Senior Java/Spring Boot Backend Architect...';
      case AssistantMode.dsa:
        return 'You are an expert in Data Structures and Algorithms...';
      case AssistantMode.systemDesign:
        return 'You are a Senior System Architect...';
      case AssistantMode.programming:
        return 'You are a Polyglot Senior Developer...';
      case AssistantMode.behavioral:
        return 'You are a Career Coach specializing in the STAR method...';
      case AssistantMode.sales:
        return 'You are a Sales Strategist...';
      case AssistantMode.negotiation:
        return 'You are a Negotiation Expert...';
      case AssistantMode.presentation:
        return 'You are a Presentation Design Expert...';
      case AssistantMode.devOps:
        return 'You are a DevOps and Cloud Engineer...';
      case AssistantMode.dataScience:
        return 'You are a Lead Data Scientist...';
    }
  }
}
