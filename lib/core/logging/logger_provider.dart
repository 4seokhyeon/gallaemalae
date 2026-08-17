import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

const appLogTag = 'SHSH';

class AppLogger {
  AppLogger(this._logger);

  final Logger _logger;

  void debug(String message) => _logger.d('[$appLogTag] $message');

  void info(String message) => _logger.i('[$appLogTag] $message');

  void warning(String message) => _logger.w('[$appLogTag] $message');

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e('[$appLogTag] $message', error: error, stackTrace: stackTrace);
  }
}

final loggerProvider = Provider<AppLogger>((ref) {
  return AppLogger(
    Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        printEmojis: false,
      ),
    ),
  );
});
