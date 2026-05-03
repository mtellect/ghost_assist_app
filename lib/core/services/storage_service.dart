import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

abstract class IStorageService {
  Future<void> init();
  
  // Secure Storage (Keychain)
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
  final _secureStorage = const FlutterSecureStorage(
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    GhostLogger.i('Storage services initialized.', tag: 'StorageService');
  }

  // Secure Storage Implementation
  @override
  Future<void> saveSecureKey(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureKey(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureKey(String key) async {
    await _secureStorage.delete(key: key);
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
