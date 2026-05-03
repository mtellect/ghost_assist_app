import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:screen_capturer/screen_capturer.dart';

class ScreenCaptureService {
  /// Captures a selected region of the screen.
  Future<File?> captureRegion() async {
    final Directory directory = await getTemporaryDirectory();
    final String imageName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
    final String imagePath = '${directory.path}/$imageName';

    final CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.region,
      imagePath: imagePath,
      silent: true,
    );

    if (capturedData != null && capturedData.imagePath != null) {
      return File(capturedData.imagePath!);
    }
    return null;
  }

  /// Captures the entire screen.
  Future<File?> captureScreen() async {
    final Directory directory = await getTemporaryDirectory();
    final String imageName = 'screenshot_full_${DateTime.now().millisecondsSinceEpoch}.png';
    final String imagePath = '${directory.path}/$imageName';

    final CapturedData? capturedData = await screenCapturer.capture(
      mode: CaptureMode.screen,
      imagePath: imagePath,
      silent: true,
    );

    if (capturedData != null && capturedData.imagePath != null) {
      return File(capturedData.imagePath!);
    }
    return null;
  }
}
