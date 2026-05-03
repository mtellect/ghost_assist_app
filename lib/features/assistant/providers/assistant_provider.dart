import 'dart:io';
import 'package:flutter/material.dart';
import '../models/assistant_mode.dart';
import '../services/i_assistant_service.dart';

import '../models/gemini_model.dart';

class AssistantProvider extends ChangeNotifier {
  final IAssistantService _assistantService;
  
  AssistantMode _currentMode = AssistantMode.dsa;
  GeminiModel _currentModel = GeminiModel.proLatest;
  String _response = '';
  bool _isLoading = false;
  File? _lastCapture;

  AssistantProvider(this._assistantService);

  AssistantMode get mode => _currentMode;
  GeminiModel get geminiModel => _currentModel;
  String get response => _response;
  bool get isLoading => _isLoading;
  File? get lastCapture => _lastCapture;

  void setMode(AssistantMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setModel(GeminiModel model) {
    _currentModel = model;
    _assistantService.setModel(model);
    notifyListeners();
  }

  Future<void> ask(String prompt, {File? screenCapture}) async {
    _isLoading = true;
    _lastCapture = screenCapture;
    notifyListeners();

    try {
      _response = await _assistantService.getResponse(
        mode: _currentMode,
        prompt: prompt,
        screenCapture: screenCapture,
      );
    } catch (e) {
      _response = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResponse() {
    _response = '';
    _lastCapture = null;
    notifyListeners();
  }

  void resetChat() {
    _assistantService.resetChat();
    clearResponse();
  }
}
