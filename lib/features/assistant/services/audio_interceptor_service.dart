import 'package:record/record.dart';
import '../../../core/utils/logger.dart';

class AudioInterceptorService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isListening = false;

  bool get isListening => _isListening;

  Future<void> startListening() async {
    try {
      if (await _recorder.hasPermission()) {
        // We don't actually need to save to a file for transcription in the future,
        // but for now we'll just initialize the stream to verify it works.
        const config = RecordConfig();
        
        // Start recording to a temporary location (we'll discard this later)
        // In a real STT implementation, we would use _recorder.startStream(config)
        await _recorder.start(config, path: 'temp_audio.m4a');
        _isListening = true;
        GhostLogger.i('Audio interceptor started listening...', tag: 'AudioService');
      } else {
        GhostLogger.w('Microphone permission denied', tag: 'AudioService');
      }
    } catch (e) {
      GhostLogger.e('Failed to start audio interceptor', tag: 'AudioService', error: e);
    }
  }

  Future<void> stopListening() async {
    try {
      await _recorder.stop();
      _isListening = false;
      GhostLogger.i('Audio interceptor stopped listening', tag: 'AudioService');
    } catch (e) {
      GhostLogger.e('Failed to stop audio interceptor', tag: 'AudioService', error: e);
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}
