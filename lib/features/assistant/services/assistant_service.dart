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
import '../../../api/base_api.dart';

class AssistantService implements IAssistantService {
  final GeminiAssistantService _geminiService;
  final OpenAiAssistantService _openaiService;
  final ClaudeAssistantService _claudeService;
  
  AIModel _currentModel = AIModel.defaultModel;

  AssistantService({
    required String geminiApiKey,
    required String openaiApiKey,
    required String anthropicApiKey,
    required ApiClient apiClient,
  })  : _geminiService = GeminiAssistantService(apiKey: geminiApiKey),
        _openaiService = OpenAiAssistantService(
          apiKey: openaiApiKey,
          apiClient: apiClient,
        ),
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
    // Ensure keys are up to date from SettingsProvider before every request
    _syncKeys();

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
  Stream<String> getResponseStream({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async* {
    _syncKeys();
    final systemPrompt = getSystemPrompt(skill);
    final fullPrompt = '$systemPrompt\n\n$prompt';

    GhostLogger.d('Streaming request to ${_currentModel.provider.name} for skill: ${skill.name}...', tag: 'AssistantService');

    if (_currentModel.provider == AIProvider.openai) {
      yield* _openaiService.getResponseStream(
        skill: skill,
        prompt: fullPrompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
    } else {
      final response = await getResponse(
        skill: skill,
        prompt: prompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );
      yield response;
    }
  }

  @override
  void resetChat() {
    _geminiService.resetChat();
    _openaiService.resetChat();
    _claudeService.resetChat();
  }

  void _syncKeys() {
    try {
      final settings = getIt<SettingsProvider>();
      
      _geminiService.updateApiKey(settings.geminiKey);
      _openaiService.updateApiKey(settings.openaiKey);
      _claudeService.updateApiKey(settings.anthropicKey);
    } catch (e) {
      GhostLogger.w('Failed to sync API keys: $e', tag: 'AssistantService');
    }
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
