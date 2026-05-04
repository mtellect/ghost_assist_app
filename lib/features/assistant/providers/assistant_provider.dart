import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ghost_assist_app/core/utils/logger.dart';
import 'package:window_manager/window_manager.dart';
import '../models/assistant_skill.dart';
import '../services/i_audio_interceptor_service.dart';
import '../services/i_assistant_service.dart';
import '../services/screen_capture_service.dart';
import '../models/ai_model.dart';
import '../../../core/native/window_stealth.dart';

class AssistantProvider extends ChangeNotifier {
  final IAssistantService _assistantService;
  final IAudioInterceptorService _audioService;
  final ScreenCaptureService _captureService;

  AssistantSkill _currentSkill = AssistantSkill.flutter;
  AIModel _currentModel = AIModel.defaultModel;
  String _response = '';
  bool _isLoading = false;
  bool _isListening = false;
  bool _isStealth = true;
  bool _isInterviewMode = false;
  File? _lastCapture;
  final TextEditingController _textController = TextEditingController();

  AssistantProvider({
    required IAssistantService assistantService,
    required IAudioInterceptorService audioService,
    required ScreenCaptureService captureService,
  }) : _assistantService = assistantService,
       _audioService = audioService,
       _captureService = captureService;

  AssistantSkill get skill => _currentSkill;
  AIModel get aiModel => _currentModel;
  String get response => _response;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;
  bool get isStealth => _isStealth;
  bool get isInterviewMode => _isInterviewMode;
  File? get lastCapture => _lastCapture;
  TextEditingController get textController => _textController;

  void toggleInterviewMode() {
    _isInterviewMode = !_isInterviewMode;
    notifyListeners();
  }

  void setSkill(AssistantSkill skill) {
    _currentSkill = skill;
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
        'Analyze this screen content and provide help based on the current skill.',
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

  void setModel(AIModel model) {
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
        final file = File(path);
        final size = await file.length();
        
        // Skip if the file is too small (e.g., < 2KB is likely empty/silence)
        if (size > 2048) {
          await ask(
            'I just spoke. Please transcribe my question and answer it based on the current skill.',
            audioFile: file,
          );
        } else {
          GhostLogger.i('Audio recording too short or empty, skipping processing.', tag: 'AssistantProvider');
        }
      }
    } else {
      await _audioService.startListening(
        isInterviewMode: _isInterviewMode,
        onAutoStop: (path) async {
          _isListening = false;
          notifyListeners();
          
          final file = File(path);
          final size = await file.length();
          
          if (size > 2048) {
            await ask(
              'I just spoke. Please transcribe my question and answer it based on the current skill.',
              audioFile: file,
            );
          } else {
            GhostLogger.i('Audio auto-stop: recording too short or empty, skipping.', tag: 'AssistantProvider');
          }

          // AUTO-RESTART: Only if Interview Mode is active
          if (!_isListening && _isInterviewMode) {
             toggleListening(); 
          }
        },
      );
      _isListening = _audioService.isListening;
      notifyListeners();
    }
  }

  Future<void> ask(String prompt, {File? screenCapture, File? audioFile}) async {
    _isLoading = true;
    _response = ''; // Clear previous response
    if (screenCapture != null) _lastCapture = screenCapture;
    notifyListeners();

    try {
      final stream = _assistantService.getResponseStream(
        skill: _currentSkill,
        prompt: prompt,
        screenCapture: screenCapture,
        audioFile: audioFile,
      );

      await for (final chunk in stream) {
        _response = chunk;
        notifyListeners();
      }
    } catch (e) {
      _response = 'Error: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> smartAsk(String prompt) async {
    // Automatically capture screen for contextual expert actions
    final file = await _captureService.captureScreen();
    await ask(prompt, screenCapture: file);
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

  Future<void> sendTextQuery() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    
    // We removed auto-capture here to prevent flicker on Windows.
    // Use dedicated capture buttons if visual context is needed.
    await ask(text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
