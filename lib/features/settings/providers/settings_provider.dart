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

  // UI-Session State: Managed controllers for skill prompts
  final Map<AssistantSkill, TextEditingController> _skillControllers = {};
  final _geminiKeyController = TextEditingController();
  final _openaiKeyController = TextEditingController();
  final _anthropicKeyController = TextEditingController();

  SettingsProvider(this._storage);

  // Getters for keys and controllers
  String get geminiKey => _geminiKey;
  String get openaiKey => _openaiKey;
  String get anthropicKey => _anthropicKey;
  bool get isLoading => _isLoading;

  // Controller Getters for UI
  TextEditingController get geminiController => _geminiKeyController;
  TextEditingController get openaiController => _openaiKeyController;
  TextEditingController get anthropicController => _anthropicKeyController;
  TextEditingController getSkillController(AssistantSkill skill) => _skillControllers[skill]!;

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

  /// Initializes controllers with current settings for an editing session.
  void startEditSession() {
    _geminiKeyController.text = _geminiKey;
    _openaiKeyController.text = _openaiKey;
    _anthropicKeyController.text = _anthropicKey;

    for (var skill in AssistantSkill.values) {
      _skillControllers[skill] = TextEditingController(
        text: _customTemplates[skill.name] ?? '',
      );
    }
  }

  /// Saves all data from controllers back to storage.
  Future<void> saveSettingsFromSession() async {
    // 1. Save Keys
    await _storage.saveSecureKey('GEMINI_API_KEY', _geminiKeyController.text.trim());
    await _storage.saveSecureKey('OPENAI_API_KEY', _openaiKeyController.text.trim());
    await _storage.saveSecureKey('ANTHROPIC_API_KEY', _anthropicKeyController.text.trim());
    
    _geminiKey = _geminiKeyController.text;
    _openaiKey = _openaiKeyController.text;
    _anthropicKey = _anthropicKeyController.text;

    // 2. Save Skill Templates
    final Map<String, String> templates = {};
    _skillControllers.forEach((skill, controller) {
      templates[skill.name] = controller.text;
    });
    _customTemplates = templates;
    await _storage.saveString('CUSTOM_TEMPLATES', jsonEncode(templates));
    
    notifyListeners();
  }

  /// Cleans up controllers to prevent memory leaks.
  void disposeControllers() {
    _geminiKeyController.dispose();
    _openaiKeyController.dispose();
    _anthropicKeyController.dispose();
    for (var controller in _skillControllers.values) {
      controller.dispose();
    }
    _skillControllers.clear();
  }

  String? getCustomTemplate(AssistantSkill skill) {
    return _customTemplates[skill.name];
  }
}
