import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ghost_assist_app/features/transcription/services/i_whisper_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../core/utils/logger.dart';

class TranscriptionProvider extends ChangeNotifier {
  final IWhisperService _whisperService;
  final AudioRecorder _recorder = AudioRecorder();

  bool _isTranscribing = false;
  final List<String> _currentTranscript = [];
  final List<String> _history = [];
  Timer? _chunkTimer;
  int _chunkCount = 0;

  TranscriptionProvider({required IWhisperService whisperService})
    : _whisperService = whisperService;

  bool get isTranscribing => _isTranscribing;
  List<String> get currentTranscript => _currentTranscript;
  List<String> get history => _history;

  Future<void> startLiveTranscription() async {
    if (_isTranscribing) return;

    if (!_whisperService.isInitialized) {
      GhostLogger.w(
        'Whisper not initialized. Cannot start transcription.',
        tag: 'TranscriptionProvider',
      );
      return;
    }

    if (!await _recorder.hasPermission()) {
      GhostLogger.e('Microphone permission denied.', tag: 'TranscriptionProvider');
      return;
    }

    _isTranscribing = true;
    _currentTranscript.clear();
    _currentTranscript.add('Listening...');
    _history.clear();
    notifyListeners();

    _startNewChunk();
  }

  Future<void> stopLiveTranscription() async {
    _isTranscribing = false;
    _chunkTimer?.cancel();
    _chunkTimer = null;
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (e) {
      GhostLogger.w('Defensive recorder stop warning: $e', tag: 'TranscriptionProvider');
    }
    _currentTranscript.clear();
    notifyListeners();
  }

  void _startNewChunk() async {
    if (!_isTranscribing) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final chunkPath = p.join(tempDir.path, 'whisper_chunk_${_chunkCount++}.wav');

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      );

      await _recorder.start(config, path: chunkPath);

      // Every 4 seconds, process the chunk and start a new one
      _chunkTimer = Timer(const Duration(seconds: 4), () async {
        if (!_isTranscribing) return;

        final savedPath = await _recorder.stop();
        _startNewChunk(); // Recursively start next chunk immediately to minimize gap

        if (savedPath != null) {
          _processChunk(savedPath);
        }
      });
    } catch (e) {
      GhostLogger.e('Failed to start audio chunk', tag: 'TranscriptionProvider', error: e);
      stopLiveTranscription();
    }
  }

  Future<void> _processChunk(String path) async {
    final text = await _whisperService.transcribe(path);

    if (!_isTranscribing) return; // Guard: Don't process if stopped in the meantime

    if (text != null && text.isNotEmpty) {
      // Remove placeholder if it exists
      _currentTranscript.remove('Listening...');

      _currentTranscript.add(text);
      _history.add(text);

      // Keep active transcript view to last 5 lines for HUD readability
      if (_currentTranscript.length > 5) _currentTranscript.removeAt(0);

      // Keep session history manageable
      if (_history.length > 500) _history.removeAt(0);

      notifyListeners();

      // Cleanup chunk file
      try {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
      } catch (e) {
        GhostLogger.w('Failed to delete chunk file: $path', tag: 'TranscriptionProvider');
      }
    }
  }

  @override
  void dispose() {
    _chunkTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }
}
