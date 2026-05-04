import 'dart:async';
import 'package:record/record.dart';
import '../../../core/utils/logger.dart';

import 'i_audio_interceptor_service.dart';

class AudioInterceptorService implements IAudioInterceptorService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isListening = false;
  StreamSubscription<Amplitude>? _amplitudeSub;
  DateTime? _lastVoiceTime;
  double _silenceThreshold = -30.0; 
  Duration _silenceDuration = const Duration(milliseconds: 2000);
  double _movingAverageAmplitude = -100.0;
  final double _smoothingFactor = 0.3; 

  @override
  bool get isListening => _isListening;

  @override
  Future<void> startListening({bool isInterviewMode = false, Function(String path)? onAutoStop}) async {
    // Set dynamic thresholds based on mode
    _silenceThreshold = isInterviewMode ? -40.0 : -30.0;
    _silenceDuration = isInterviewMode ? const Duration(milliseconds: 6000) : const Duration(milliseconds: 2000);
    _movingAverageAmplitude = -100.0; // Reset moving average

    try {
      if (await _recorder.hasPermission()) {
        const config = RecordConfig(
          noiseSuppress: true,
          echoCancel: true,
          autoGain: true,
        );
        final path = 'temp_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(config, path: path);
        _isListening = true;
        _lastVoiceTime = DateTime.now();

        GhostLogger.i('Audio interceptor started listening...', tag: 'AudioService');

        // Start amplitude monitoring for VAD
        _amplitudeSub = _recorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((
          amp,
        ) async {
          // Update moving average: smoother signal prevents jittery stops
          _movingAverageAmplitude = (_movingAverageAmplitude * (1 - _smoothingFactor)) + (amp.current * _smoothingFactor);

          if (_movingAverageAmplitude > _silenceThreshold) {
            _lastVoiceTime = DateTime.now();
          } else {
            if (_lastVoiceTime != null &&
                DateTime.now().difference(_lastVoiceTime!) > _silenceDuration) {
              GhostLogger.i('Definitive silence detected (MA: ${_movingAverageAmplitude.toStringAsFixed(1)}dB), auto-stopping...', tag: 'AudioService');
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
