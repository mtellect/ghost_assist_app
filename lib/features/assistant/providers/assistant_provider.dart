import 'dart:io';
import 'package:flutter/material.dart';
import '../models/assistant_mode.dart';
import '../services/i_audio_interceptor_service.dart';
import '../services/i_assistant_service.dart';
import '../models/gemini_model.dart';

class AssistantProvider extends ChangeNotifier {
  final IAssistantService _assistantService;
  final IAudioInterceptorService _audioService;
  
  AssistantMode _currentMode = AssistantMode.flutter;
  GeminiModel _currentModel = GeminiModel.proLatest;
  String _response = '';
  bool _isLoading = false;
  bool _isListening = false;
  File? _lastCapture;

  AssistantProvider({
    required IAssistantService assistantService,
    required IAudioInterceptorService audioService,
  })  : _assistantService = assistantService,
        _audioService = audioService;

  AssistantMode get mode => _currentMode;
  GeminiModel get geminiModel => _currentModel;
  String get response => _response;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;
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

  Future<void> toggleListening() async {
    if (_isListening) {
      final path = await _audioService.stopListening();
      _isListening = false;
      notifyListeners();

      if (path != null) {
        // Automatically ask Gemini to analyze the audio
        await ask(
          'I just spoke. Please transcribe my question and answer it based on the current mode.',
          audioFile: File(path),
        );
      }
    } else {
      await _audioService.startListening(onAutoStop: (path) async {
        _isListening = false;
        notifyListeners();
        await ask(
          'I just spoke. Please transcribe my question and answer it based on the current mode.',
          audioFile: File(path),
        );
      });
      _isListening = _audioService.isListening;
      notifyListeners();
    }
  }

  Future<void> ask(String prompt, {File? screenCapture, File? audioFile}) async {
    _isLoading = true;
    if (screenCapture != null) _lastCapture = screenCapture;
    notifyListeners();

    try {
      _response = await _assistantService.getResponse(
        mode: _currentMode,
        prompt: prompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
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
