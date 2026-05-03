import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class GhostLogger {
  static LogLevel _currentLogLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  static void setLogLevel(LogLevel level) {
    _currentLogLevel = level;
  }

  static void d(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  static void i(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  static void w(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  static void e(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _currentLogLevel.index) return;

    final timestamp = DateTime.now().toIso8601String().split('T').last.substring(0, 8);
    final tagStr = tag != null ? '[$tag] ' : '';
    final emoji = _getEmoji(level);

    final fullMessage = '$emoji $timestamp $tagStr$message';

    debugPrint(fullMessage);

    if (error != null) {
      debugPrint('   Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '🚨';
    }
  }
}
