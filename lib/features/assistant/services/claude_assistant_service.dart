import 'dart:io';
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import '../models/ai_model.dart';
import '../models/assistant_mode.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

class ClaudeAssistantService implements IAssistantService {
  final String apiKey;
  AIModel _currentModel = AIModel.claude35Sonnet;
  final List<Message> _history = [];
  late final AnthropicClient _client;

  ClaudeAssistantService({required this.apiKey}) {
    _client = AnthropicClient(apiKey: apiKey);
  }

  @override
  void setModel(AIModel model) {
    _currentModel = model;
  }

  @override
  Future<String> getResponse({
    required AssistantMode mode,
    required String prompt,
    File? screenCapture,
    File? audioFile,
  }) async {
    try {
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
  void resetChat() {
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantMode mode) => ''; // Handled by orchestrator
}
