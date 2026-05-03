import 'dart:io';
import 'package:flutter/material.dart';
import '../models/assistant_mode.dart';
import '../services/i_assistant_service.dart';

class AssistantProvider extends ChangeNotifier {
  final IAssistantService _service;

  AssistantMode _currentMode = AssistantMode.dsa;
  String _response = '';
  bool _isLoading = false;
  bool _usePro = true;
  File? _lastCapture;

  AssistantProvider(this._service);

  AssistantMode get currentMode => _currentMode;
  String get response => _response;
  bool get isLoading => _isLoading;
  bool get usePro => _usePro;
  File? get lastCapture => _lastCapture;

  void setMode(AssistantMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setUsePro(bool usePro) {
    _usePro = usePro;
    _service.setUsePro(usePro);
    notifyListeners();
  }

  Future<void> ask(String prompt, {File? screenCapture}) async {
    _isLoading = true;
    _lastCapture = screenCapture;
    notifyListeners();

    try {
      _response = await _service.getResponse(
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
    _service.resetChat();
    clearResponse();
  }
}
