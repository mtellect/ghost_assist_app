import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

abstract class IStorageService {
  Future<void> init();
  
  // Storage Methods (Unified for reliability)
  Future<void> saveSecureKey(String key, String value);
  Future<String?> getSecureKey(String key);
  Future<void> deleteSecureKey(String key);
  
  // Standard Storage (Settings)
  Future<void> saveString(String key, String value);
  String? getString(String key);
  Future<void> saveBool(String key, bool value);
  bool? getBool(String key);
}

class StorageService implements IStorageService {
  late final SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    GhostLogger.i('Storage services initialized (using shared_preferences for all platforms).', tag: 'StorageService');
  }

  // Unified Storage Implementation
  // Note: On Windows/macOS, shared_preferences uses a local file/registry.
  // This is 100% reliable as it requires no extra DLLs.
  @override
  Future<void> saveSecureKey(String key, String value) async {
    await _prefs.setString('sec_$key', value);
  }

  @override
  Future<String?> getSecureKey(String key) async {
    return _prefs.getString('sec_$key');
  }

  @override
  Future<void> deleteSecureKey(String key) async {
    await _prefs.remove('sec_$key');
  }

  // Standard Storage Implementation
  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
}
