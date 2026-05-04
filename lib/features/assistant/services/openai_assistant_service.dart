import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dart_openai/dart_openai.dart';
import '../models/ai_model.dart';
import '../models/assistant_skill.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';
import '../../../api/base_api.dart';

class OpenAiAssistantService implements IAssistantService {
  String apiKey;
  final ApiClient apiClient;
  AIModel _currentModel = AIModel.gpt4o;
  final List<Map<String, dynamic>> _history = [];

  OpenAiAssistantService({
    required this.apiKey,
    required this.apiClient,
  }) {
    _initOpenAI();
  }

  void _initOpenAI() {
    if (apiKey.isNotEmpty) {
      OpenAI.apiKey = apiKey;
      OpenAI.requestsTimeOut = const Duration(seconds: 60);
    }
  }

  void updateApiKey(String newKey) {
    if (apiKey == newKey) return;
    apiKey = newKey;
    _initOpenAI();
    GhostLogger.i('OpenAI API Key updated.', tag: 'OpenAIService');
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
      String finalPrompt = prompt;

      // 1. Handle Audio Transcription if provided (using Whisper)
      if (audioFile != null) {
        GhostLogger.i('Transcribing audio with Whisper...', tag: 'OpenAIService');
        final transcription = await OpenAI.instance.audio.createTranscription(
          model: "whisper-1",
          file: audioFile,
          responseFormat: OpenAIAudioResponseFormat.json,
        );
        
        if (transcription is OpenAITranscriptionModel) {
          finalPrompt = transcription.text;
          GhostLogger.d('Transcription complete: "$finalPrompt"', tag: 'OpenAIService');
        } else {
          GhostLogger.w('Unexpected transcription format received.', tag: 'OpenAIService');
        }
      }

      GhostLogger.i('Sending request to OpenAI via ApiClient: ${_currentModel.id}', tag: 'OpenAIService');
      
      // 2. Build multi-modal content
      final List<Map<String, dynamic>> contentItems = [
        {
          "type": "text",
          "text": finalPrompt,
        },
      ];

      if (screenCapture != null) {
        GhostLogger.d('Including screen capture...', tag: 'OpenAIService');
        final bytes = await screenCapture.readAsBytes();
        final base64Image = base64Encode(bytes);
        contentItems.add({
          "type": "image_url",
          "image_url": {
            "url": "data:image/png;base64,$base64Image",
          },
        });
      }

      final userMessage = {
        "role": "user",
        "content": contentItems,
      };

      _history.add(userMessage);

      // 3. Use ApiClient's Dio instance for the request
      // This gives us automatic logging, interceptors, and error handling
      final response = await apiClient.dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: {
          "model": _currentModel.id,
          "messages": _history,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('OpenAI Error: ${response.statusMessage} (${response.statusCode})');
      }

      final responseText = response.data['choices'][0]['message']['content'] ?? 'No response.';
      
      GhostLogger.i('Successfully received response from OpenAI (${responseText.length} chars)', tag: 'OpenAIService');

      _history.add({
        "role": "assistant",
        "content": responseText,
      });

      return responseText;
    } catch (e) {
      GhostLogger.e('OpenAI Request Failed', tag: 'OpenAIService', error: e);
      return 'OpenAI Error: $e';
    }
  }

  @override
  void resetChat() {
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantSkill skill) => ''; // Handled by orchestrator
}
