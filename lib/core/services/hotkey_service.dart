import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import '../utils/logger.dart';

class HotKeyService {
  Future<void> init() async {
    await hotKeyManager.unregisterAll();
  }

  Future<void> registerHotKey({
    required PhysicalKeyboardKey keyCode,
    required List<HotKeyModifier> modifiers,
    required String identifier,
    required VoidCallback onPressed,
  }) async {
    final hotKey = HotKey(
      key: keyCode,
      modifiers: modifiers,
      identifier: identifier,
    );

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        GhostLogger.i('HotKey Pressed: ${hotKey.identifier}', tag: 'HotKeyService');
        onPressed();
      },
    );
    
    GhostLogger.d('Registered HotKey: $identifier', tag: 'HotKeyService');
  }

  Future<void> unregisterAll() async {
    await hotKeyManager.unregisterAll();
  }
}
