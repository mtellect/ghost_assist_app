import '../utils/logger.dart';

class PermissionService {
  /// Stubbed permission check.
  /// We rely on the native OS to prompt for microphone access when the 'record' 
  /// package starts for the first time.
  Future<bool> checkAndRequestPermissions() async {
    GhostLogger.i('Permission check bypassed. Relying on OS native prompts.', tag: 'PermissionService');
    return true;
  }

  /// Opens the system settings (Stubbed).
  Future<void> openSettings() async {
    GhostLogger.i('Open settings requested.', tag: 'PermissionService');
  }
}
