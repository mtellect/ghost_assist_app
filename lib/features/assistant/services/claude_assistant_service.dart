import 'dart:io';
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import '../models/ai_model.dart';
import '../models/assistant_skill.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

class ClaudeAssistantService implements IAssistantService {
  String _apiKey;
  AIModel _currentModel = AIModel.claude35Sonnet;
  final List<Message> _history = [];
  late AnthropicClient _client;

  ClaudeAssistantService({required String apiKey}) : _apiKey = apiKey {
    _initClient();
  }

  void _initClient() {
    _client = AnthropicClient(apiKey: _apiKey);
  }

  void updateApiKey(String newKey) {
    if (_apiKey == newKey) return;
    _apiKey = newKey;
    _initClient();
    GhostLogger.i('Claude API Key updated.', tag: 'ClaudeService');
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
        return 'Error: Claude API Key is missing. Please set it in Settings.';
      }

      // Temporary: Text-only implementation to ensure compilation
      final userMessage = Message(
        role: MessageRole.user,
        content: MessageContent.text(prompt),
      );

      _history.add(userMessage);

      final response = await _client.createMessage(
        request: CreateMessageRequest(
          model: Model.modelId(_currentModel.id),
          messages: _history,
          maxTokens: 4096,
        ),
      );

      final responseText = response.content.text;
      
      _history.add(Message(
        role: MessageRole.assistant,
        content: MessageContent.text(responseText),
      ));

      return responseText;
    } catch (e) {
      GhostLogger.e('Claude Error', tag: 'ClaudeService', error: e);
      return 'Claude Error: $e';
    }
  }

  @override
  Stream<String> getResponseStream({
    required AssistantSkill skill,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async* {
    // Claude streaming to be implemented
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
