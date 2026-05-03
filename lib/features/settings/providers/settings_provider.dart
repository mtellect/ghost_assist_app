import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../assistant/models/assistant_skill.dart';

class SettingsProvider extends ChangeNotifier {
  final IStorageService _storage;

  String _geminiKey = '';
  String _openaiKey = '';
  String _anthropicKey = '';
  Map<String, String> _customTemplates = {};
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
    
    final templatesJson = _storage.getString('CUSTOM_TEMPLATES');
    if (templatesJson != null) {
      try {
        _customTemplates = Map<String, String>.from(jsonDecode(templatesJson));
      } catch (_) {
        _customTemplates = {};
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  String? getCustomTemplate(AssistantSkill skill) {
    return _customTemplates[skill.name];
  }

  Map<String, String> get allTemplates => Map.unmodifiable(_customTemplates);

  Future<void> saveTemplates(Map<String, String> templates) async {
    _customTemplates = templates;
    await _storage.saveString('CUSTOM_TEMPLATES', jsonEncode(templates));
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
