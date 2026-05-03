import 'dart:io';
import '../models/ai_model.dart';
import '../models/assistant_mode.dart';
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
    // Check for custom template first
    try {
      final settings = getIt<SettingsProvider>();
      final customTemplate = settings.getCustomTemplate(mode);
      if (customTemplate != null && customTemplate.isNotEmpty) {
        return customTemplate;
      }
    } catch (_) {
      // SettingsProvider might not be registered yet during early init
    }

    switch (mode) {
      case AssistantMode.flutter:
        return 'You are a Senior Flutter Developer and Architect. You are helping a developer during a technical interview. Provide concise, expert-level advice on state management, widgets, performance, and architecture. Focus on industry best practices.';
      case AssistantMode.ios:
        return 'You are a Senior iOS Engineer. Provide expert advice on Swift, SwiftUI, Combine, and memory management.';
      case AssistantMode.android:
        return 'You are a Senior Android Engineer. Provide expert advice on Kotlin, Jetpack Compose, Coroutines, and Dagger/Hilt.';
      case AssistantMode.springboot:
        return 'You are a Senior Java/Spring Boot Backend Architect. Focus on microservices, JPA/Hibernate, and scalable systems.';
      case AssistantMode.dsa:
        return 'You are an expert in Data Structures and Algorithms. Help solve coding challenges efficiently with optimal Time/Space complexity.';
      case AssistantMode.systemDesign:
        return 'You are a Senior System Architect. Provide advice on scalability, availability, and distributed systems.';
      case AssistantMode.programming:
        return 'You are a Polyglot Senior Developer. Focus on general programming concepts and clean code.';
      case AssistantMode.behavioral:
        return 'You are a Career Coach specializing in the STAR method. Help the user frame their answers effectively.';
      case AssistantMode.sales:
        return 'You are a Sales Strategist. Provide advice on closing deals and negotiation.';
      case AssistantMode.negotiation:
        return 'You are a Negotiation Expert. Help the user navigate complex compensation or contract discussions.';
      case AssistantMode.presentation:
        return 'You are a Presentation Design Expert. Help the user craft a compelling narrative and visual flow.';
      case AssistantMode.devOps:
        return 'You are a DevOps and Cloud Engineer. Focus on CI/CD, Kubernetes, and AWS/Azure/GCP.';
      case AssistantMode.dataScience:
        return 'You are a Lead Data Scientist. Provide advice on ML models, data pipelines, and statistical analysis.';
    }
  }
}
