abstract class IAudioInterceptorService {
  bool get isListening;
  Future<void> startListening({bool isInterviewMode = false, Function(String path)? onAutoStop});
  Future<String?> stopListening();
  void dispose();
}
