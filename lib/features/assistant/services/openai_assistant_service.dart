import 'dart:convert';
import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import '../models/ai_model.dart';
import '../models/assistant_mode.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

class OpenAiAssistantService implements IAssistantService {
  final String apiKey;
  AIModel _currentModel = AIModel.gpt4o;
  final List<OpenAIChatCompletionChoiceMessageModel> _history = [];

  OpenAiAssistantService({required this.apiKey}) {
    OpenAI.apiKey = apiKey;
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
      final List<OpenAIChatCompletionChoiceMessageContentItemModel> contentItems = [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
      ];

      if (screenCapture != null) {
        final bytes = await screenCapture.readAsBytes();
        final base64Image = base64Encode(bytes);
        contentItems.add(
          OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
            "data:image/png;base64,$base64Image",
          ),
        );
      }

      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: contentItems,
      );

      _history.add(userMessage);

      final completion = await OpenAI.instance.chat.create(
        model: _currentModel.id,
        messages: _history,
      );

      final responseText = completion.choices.first.message.content?.first.text ?? 'No response.';
      
      _history.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.assistant,
        content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(responseText)],
      ));

      return responseText;
    } catch (e) {
      GhostLogger.e('OpenAI Error', tag: 'OpenAIService', error: e);
      return 'OpenAI Error: $e';
    }
  }

  @override
  void resetChat() {
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantMode mode) => ''; // Handled by orchestrator
}
