abstract class IAudioInterceptorService {
  bool get isListening;
  Future<void> startListening({Function(String path)? onAutoStop});
  Future<String?> stopListening();
  void dispose();
}
