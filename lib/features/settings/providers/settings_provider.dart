import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final IStorageService _storage;

  String _geminiKey = '';
  String _openaiKey = '';
  String _anthropicKey = '';
  bool _isLoading = false;

  SettingsProvider(this._storage);

  String get geminiKey => _geminiKey;
  String get openaiKey => _openaiKey;
  String get anthropicKey => _anthropicKey;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _geminiKey = await _storage.getSecureKey('GEMINI_API_KEY') ?? '';
    _openaiKey = await _storage.getSecureKey('OPENAI_API_KEY') ?? '';
    _anthropicKey = await _storage.getSecureKey('ANTHROPIC_API_KEY') ?? '';

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveKeys({
    required String gemini,
    required String openai,
    required String anthropic,
  }) async {
    await _storage.saveSecureKey('GEMINI_API_KEY', gemini.trim());
    await _storage.saveSecureKey('OPENAI_API_KEY', openai.trim());
    await _storage.saveSecureKey('ANTHROPIC_API_KEY', anthropic.trim());
    
    _geminiKey = gemini;
    _openaiKey = openai;
    _anthropicKey = anthropic;
    
    notifyListeners();
  }
}
