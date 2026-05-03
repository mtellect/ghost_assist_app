import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/assistant_mode.dart';
import 'i_assistant_service.dart';
import '../../../core/utils/logger.dart';

import '../models/gemini_model.dart';

class AssistantService implements IAssistantService {
  final String apiKey;
  late final Map<GeminiModel, GenerativeModel> _models;
  GeminiModel _currentModel = GeminiModel.proLatest;

  late ChatSession _chatSession;
  final List<Content> _history = [];

  AssistantService({required this.apiKey}) {
    GhostLogger.i('Initializing models (Key length: ${apiKey.length})...', tag: 'AssistantService');
    
    _models = {
      GeminiModel.proLatest: GenerativeModel(
        model: GeminiModel.proLatest.id,
        apiKey: apiKey,
      ),
      GeminiModel.flashLatest: GenerativeModel(
        model: GeminiModel.flashLatest.id,
        apiKey: apiKey,
      ),
    };

    _chatSession = _models[_currentModel]!.startChat();
    GhostLogger.i('Models initialized successfully.', tag: 'AssistantService');
  }

  @override
  void setModel(GeminiModel model) {
    if (_currentModel != model) {
      _currentModel = model;
      GhostLogger.i('Switching to model: ${model.label}', tag: 'AssistantService');
      // Restart chat with new model to maintain consistency
      _chatSession = _models[model]!.startChat(history: _history);
    }
  }

  @override
  Future<String> getResponse({
    required AssistantMode mode,
    required String prompt,
    File? screenCapture,
  }) async {
    final systemPrompt = getSystemPrompt(mode);
    
    try {
      final activeModel = _models[_currentModel]!;
      GhostLogger.d('Getting response using ${_currentModel.label}', tag: 'AssistantService');

      if (screenCapture != null) {
        final imageBytes = await screenCapture.readAsBytes();
        final content = Content.multi([
          TextPart('$systemPrompt\n\n$prompt'),
          DataPart('image/png', imageBytes),
        ]);
        
        final response = await activeModel.generateContent([content]);
        final responseText = response.text ?? 'No response from AI.';
        
        // Add to history
        _history.add(content);
        _history.add(Content.model([TextPart(responseText)]));
        
        return responseText;
      } else {
        final response = await _chatSession.sendMessage(
          Content.text('$systemPrompt\n\n$prompt'),
        );
        return response.text ?? 'No response from AI.';
      }
    } catch (e, stack) {
      GhostLogger.e('Error generating response', tag: 'AssistantService', error: e, stackTrace: stack);
      return 'Error generating response: $e';
    }
  }

  @override
  void resetChat() {
    _chatSession = _models[_currentModel]!.startChat();
    _history.clear();
  }

  @override
  String getSystemPrompt(AssistantMode mode) {
    switch (mode) {
      case AssistantMode.dsa:
        return '''You are an expert in Data Structures and Algorithms. 
        Focus on:
        1. Optimized solutions (Time/Space complexity).
        2. Corner cases and edge cases.
        3. Step-by-step logic.
        Use clean code snippets. If the user provides an image, extract the problem description first.''';
      case AssistantMode.systemDesign:
        return '''You are a Senior System Architect. 
        Focus on:
        1. Scalability, Reliability, and Availability.
        2. Database choices (SQL vs NoSQL), Caching, and Load Balancing.
        3. Trade-offs for every decision.
        Use ASCII diagrams or bulleted architecture patterns.''';
      case AssistantMode.programming:
        return '''You are a Polyglot Senior Developer. 
        Focus on:
        1. Idiomatic code and best practices.
        2. Debugging tips and performance optimizations.
        3. Modern language features (e.g., Dart 3, Python 3.12, Java 21).''';
      case AssistantMode.behavioral:
        return '''You are a Career Coach specializing in the STAR method.
        Focus on:
        1. Situation, Task, Action, Result.
        2. Leadership principles and conflict resolution.
        3. Professional tone and impact-oriented language.''';
      case AssistantMode.sales:
        return '''You are a Sales Strategist. 
        Focus on:
        1. Objection handling (Feel-Felt-Found).
        2. Value-based selling and discovery questions.
        3. Closing techniques and pipeline management.''';
      case AssistantMode.negotiation:
        return '''You are a Negotiation Expert. 
        Focus on:
        1. Win-Win strategies and BATNA.
        2. Psychological levers and anchoring.
        3. Identifying the other party's hidden interests.''';
      case AssistantMode.presentation:
        return '''You are a Presentation Design Expert. 
        Focus on:
        1. Narrative structure (Hook, Core, Call to action).
        2. Visual hierarchy and cognitive load reduction.
        3. Delivery tips (Pacing, Tone, Engagement).''';
      case AssistantMode.devOps:
        return '''You are a DevOps and Cloud Engineer. 
        Focus on:
        1. CI/CD pipelines and Infrastructure as Code (Terraform/Ansible).
        2. Containerization (Docker/K8s) and Observability.
        3. Cost optimization and security hardening.''';
      case AssistantMode.dataScience:
        return '''You are a Lead Data Scientist. 
        Focus on:
        1. Statistical significance and experimental design (A/B testing).
        2. Model trade-offs (Bias-Variance) and evaluation metrics.
        3. Feature engineering and data cleaning strategies.''';
    }
  }
}
