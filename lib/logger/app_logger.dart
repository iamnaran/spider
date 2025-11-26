import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 4, 
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  static void configureLogging() {
    if (kDebugMode) {
      Logger.level = Level.debug; 
    } else {
      Logger.level = Level.off;
    }
  }

  static void showDebug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static void showInfo(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void showLog(String message) {
    if (kDebugMode) _logger.w(message);
  }
}
