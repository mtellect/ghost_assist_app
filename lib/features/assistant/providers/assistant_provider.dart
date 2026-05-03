import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../models/assistant_mode.dart';
import '../services/i_audio_interceptor_service.dart';
import '../services/i_assistant_service.dart';
import '../services/screen_capture_service.dart';
import '../models/gemini_model.dart';
import '../../../core/native/window_stealth.dart';

class AssistantProvider extends ChangeNotifier {
  final IAssistantService _assistantService;
  final IAudioInterceptorService _audioService;
  final ScreenCaptureService _captureService;

  AssistantMode _currentMode = AssistantMode.flutter;
  GeminiModel _currentModel = GeminiModel.defaultModel;
  String _response = '';
  bool _isLoading = false;
  bool _isListening = false;
  bool _isStealth = true;
  File? _lastCapture;

  AssistantProvider({
    required IAssistantService assistantService,
    required IAudioInterceptorService audioService,
    required ScreenCaptureService captureService,
  }) : _assistantService = assistantService,
       _audioService = audioService,
       _captureService = captureService;

  AssistantMode get mode => _currentMode;
  GeminiModel get geminiModel => _currentModel;
  String get response => _response;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;
  bool get isStealth => _isStealth;
  File? get lastCapture => _lastCapture;

  void setMode(AssistantMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  Future<void> toggleStealth() async {
    _isStealth = !_isStealth;

    // 1. Native stealth (invisible to screen sharing/recording)
    // This is the real "Magic" - it hides the window from others but NOT you.
    await WindowStealth.setStealthMode(_isStealth);

    // 2. Ingnore for now - Interactivity (Optional: keep interactive so you can scroll/copy)
    // await windowManager.setIgnoreMouseEvents(false);

    // 3. User Visibility (Always 100% for the user)
    await windowManager.setOpacity(1.0);

    // 4. Force background refresh and focus
    await windowManager.setBackgroundColor(Colors.transparent);
    if (!_isStealth) await windowManager.focus();

    notifyListeners();
  }

  Future<void> captureRegion() async {
    final file = await _captureService.captureRegion();
    if (file != null) {
      await ask(
        'Analyze this screen content and provide help based on the current mode.',
        screenCapture: file,
      );
    }
  }

  Future<void> captureFullScreen() async {
    final file = await _captureService.captureScreen();
    if (file != null) {
      await ask('Analyze the full screen.', screenCapture: file);
    }
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
      await _audioService.startListening(
        onAutoStop: (path) async {
          _isListening = false;
          notifyListeners();
          await ask(
            'I just spoke. Please transcribe my question and answer it based on the current mode.',
            audioFile: File(path),
          );
        },
      );
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
