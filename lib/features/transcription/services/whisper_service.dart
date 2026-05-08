import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:whisper_ggml_plus/whisper_ggml_plus.dart';
import 'i_whisper_service.dart';
import '../../../core/utils/logger.dart';

class WhisperService implements IWhisperService {
  Whisper? _whisper;
  bool _isInitialized = false;
  String? _modelPath;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> ensureModelLoaded() async {
    if (_isInitialized) return;

    final appDocDir = await getApplicationSupportDirectory();
    final modelPath = p.join(appDocDir.path, 'ggml-tiny.en.bin');
    final modelFile = File(modelPath);

    if (!modelFile.existsSync()) {
      GhostLogger.i('Extracting Whisper model from assets...', tag: 'WhisperService');
      
      // Ensure directory exists
      await modelFile.parent.create(recursive: true);

      // Load from assets and write to filesystem
      final data = await rootBundle.load('assets/ggml-tiny.en.bin');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await modelFile.writeAsBytes(bytes);
      
      GhostLogger.i('Model extraction complete.', tag: 'WhisperService');
    }

    await initialize(modelPath);
  }

  @override
  Future<void> initialize(String modelPath) async {
    try {
      if (!File(modelPath).existsSync()) {
        throw Exception('Whisper model file not found at $modelPath');
      }

      _modelPath = modelPath;
      _whisper = Whisper(model: WhisperModel.tinyEn);
      _isInitialized = true;
      GhostLogger.i('Whisper initialized successfully.', tag: 'WhisperService');
    } catch (e) {
      GhostLogger.e('Failed to initialize Whisper', tag: 'WhisperService', error: e);
      rethrow;
    }
  }

  @override
  Future<String?> transcribe(String audioFilePath) async {
    if (!_isInitialized || _whisper == null || _modelPath == null) {
      GhostLogger.w('Whisper not initialized. Call initialize first.', tag: 'WhisperService');
      return null;
    }

    try {
      final File audioFile = File(audioFilePath);
      if (!audioFile.existsSync()) {
        GhostLogger.e('Audio file not found: $audioFilePath', tag: 'WhisperService');
        return null;
      }

      GhostLogger.d('Starting transcription for: ${p.basename(audioFilePath)}', tag: 'WhisperService');
      
      final WhisperTranscribeResponse result = await _whisper!.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: audioFilePath,
          language: 'en',
          isVerbose: false,
        ),
        modelPath: _modelPath!,
      );

      return result.text.trim();
    } catch (e) {
      GhostLogger.e('Transcription error', tag: 'WhisperService', error: e);
      return null;
    }
  }

  @override
  void dispose() {
    _whisper?.dispose();
    _whisper = null;
    _isInitialized = false;
  }
}
