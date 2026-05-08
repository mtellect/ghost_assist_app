abstract class IWhisperService {
  bool get isInitialized;
  Future<void> ensureModelLoaded();
  Future<void> initialize(String modelPath);
  Future<String?> transcribe(String audioFilePath);
  void dispose();
}
