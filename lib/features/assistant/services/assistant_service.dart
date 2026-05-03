import 'dart:io';
import '../models/ai_model.dart';
import '../models/assistant_skill.dart';
import 'i_assistant_service.dart';
import 'gemini_assistant_service.dart';
import 'openai_assistant_service.dart';
import 'claude_assistant_service.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/startup/startup_service.dart';
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
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async {
    final systemPrompt = getSystemPrompt(skill);
    final fullPrompt = '$systemPrompt\n\n$prompt';

    GhostLogger.d('Routing request to ${_currentModel.provider.name} for skill: ${skill.name}...', tag: 'AssistantService');

    if (_currentModel.provider == AIProvider.gemini) {
      return _geminiService.getResponse(
        skill: skill,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    } else if (_currentModel.provider == AIProvider.openai) {
      return _openaiService.getResponse(
        skill: skill,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    } else {
      return _claudeService.getResponse(
        skill: skill,
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
  String getSystemPrompt(AssistantSkill skill) {
    // Check for custom template first
    try {
      final settings = getIt<SettingsProvider>();
      final customTemplate = settings.getCustomTemplate(skill);
      if (customTemplate != null && customTemplate.isNotEmpty) {
        return customTemplate;
      }
    } catch (_) {
      // SettingsProvider might not be registered yet during early init
    }

    switch (skill) {
      case AssistantSkill.flutter:
        return 'You are a Senior Flutter Developer and Architect. Provide concise, expert-level advice on state management, performance, and architecture.';
      case AssistantSkill.ios:
        return 'You are a Senior iOS Engineer. Provide expert advice on Swift, SwiftUI, and memory management.';
      case AssistantSkill.android:
        return 'You are a Senior Android Engineer. Provide expert advice on Kotlin, Jetpack Compose, and Coroutines.';
      case AssistantSkill.springboot:
        return 'You are a Senior Java/Spring Boot Backend Architect. Focus on microservices and scalable systems.';
      case AssistantSkill.dsa:
        return 'You are an expert in Data Structures and Algorithms. Help solve coding challenges efficiently.';
      case AssistantSkill.systemDesign:
        return 'You are a Senior System Architect. Provide advice on scalability and distributed systems.';
      case AssistantSkill.programming:
        return 'You are a Polyglot Senior Developer. Focus on general programming concepts and clean code.';
      case AssistantSkill.behavioral:
        return 'You are a Career Coach specializing in the STAR method. Help the user frame their answers effectively.';
      case AssistantSkill.devOps:
        return 'You are a DevOps and Cloud Engineer. Focus on CI/CD, Kubernetes, and AWS/Azure/GCP.';
      case AssistantSkill.dataScience:
        return 'You are a Lead Data Scientist. Provide advice on ML models and data analysis.';
      case AssistantSkill.custom:
        return 'You are an expert AI assistant. Provide helpful, concise, and accurate information.';
    }
  }
}
