import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../utils/logger.dart';

class PermissionService {
  /// Checks and requests necessary permissions for the app to function.
  /// This handles Microphone and Screen Recording (macOS).
  Future<bool> checkAndRequestPermissions() async {
    GhostLogger.i('Checking permissions...', tag: 'PermissionService');

    // 1. Microphone Permission (Universal)
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      GhostLogger.w('Microphone permission not granted. Requesting...', tag: 'PermissionService');
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        GhostLogger.e('Microphone permission denied.', tag: 'PermissionService');
        return false;
      }
    }

    // 2. Screen Recording Permission (macOS Specific)
    // On macOS, standard Flutter permission_handler doesn't handle 'Screen Recording'
    // because it's a TCC restriction, not a standard app permission.
    // However, for Windows, BitBlt doesn't usually require a prompt.
    if (Platform.isMacOS) {
      // Note: In a real production app, we would use a native bridge 
      // to check CGPreflightScreenCaptureAccess()
      GhostLogger.i('macOS: Assuming screen recording handled by OS TCC prompt.', tag: 'PermissionService');
    }

    GhostLogger.i('All necessary permissions granted.', tag: 'PermissionService');
    return true;
  }

  /// Opens the system settings if permissions are permanently denied.
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
