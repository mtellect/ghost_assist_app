import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WindowStealth {
  static const _channel = MethodChannel('com.ghost.assist/stealth');

  /// Enables or disables stealth mode (hiding the window from screen sharing).
  static Future<void> setStealthMode(bool enabled) async {
    try {
      await _channel.invokeMethod('setStealthMode', {'enabled': enabled});
      debugPrint('Stealth mode set to: $enabled');
    } on PlatformException catch (e) {
      debugPrint('Failed to set stealth mode: ${e.message}');
    }
  }

  /// Checks if stealth mode is currently enabled.
  static Future<bool> isStealthEnabled() async {
    try {
      final bool? isEnabled = await _channel.invokeMethod('isStealthEnabled');
      return isEnabled ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check stealth mode: ${e.message}');
      return false;
    }
  }
}
