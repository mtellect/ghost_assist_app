import 'dart:async';
import 'package:record/record.dart';
import '../../../core/utils/logger.dart';

import 'i_audio_interceptor_service.dart';

class AudioInterceptorService implements IAudioInterceptorService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isListening = false;
  StreamSubscription<Amplitude>? _amplitudeSub;
  DateTime? _lastVoiceTime;
  final double _silenceThreshold = -40.0; // dB
  final Duration _silenceDuration = const Duration(seconds: 2);

  @override
  bool get isListening => _isListening;

  @override
  Future<void> startListening({Function(String path)? onAutoStop}) async {
    try {
      if (await _recorder.hasPermission()) {
        const config = RecordConfig();
        final path = 'temp_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(config, path: path);
        _isListening = true;
        _lastVoiceTime = DateTime.now();

        GhostLogger.i('Audio interceptor started listening...', tag: 'AudioService');

        // Start amplitude monitoring for VAD
        _amplitudeSub = _recorder.onAmplitudeChanged(const Duration(milliseconds: 200)).listen((
          amp,
        ) async {
          if (amp.current > _silenceThreshold) {
            _lastVoiceTime = DateTime.now();
          } else {
            if (_lastVoiceTime != null &&
                DateTime.now().difference(_lastVoiceTime!) > _silenceDuration) {
              GhostLogger.i('Silence detected, auto-stopping...', tag: 'AudioService');
              final savedPath = await stopListening();
              if (savedPath != null && onAutoStop != null) {
                onAutoStop(savedPath);
              }
            }
          }
        });
      }
    } catch (e) {
      GhostLogger.e('Failed to start audio interceptor', tag: 'AudioService', error: e);
    }
  }

  @override
  Future<String?> stopListening() async {
    try {
      await _amplitudeSub?.cancel();
      _amplitudeSub = null;
      final path = await _recorder.stop();
      _isListening = false;
      return path;
    } catch (e) {
      GhostLogger.e('Failed to stop audio interceptor', tag: 'AudioService', error: e);
      return null;
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
  }
}
