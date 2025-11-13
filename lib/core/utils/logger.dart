import 'package:logger/logger.dart' show Logger, Level, PrettyPrinter, DateTimeFormat;

/// Global logger instance for the application
/// 
/// Usage:
/// ```dart
/// AppLogger.info('This is an info message');
/// AppLogger.error('This is an error', error: e, stackTrace: stackTrace);
/// AppLogger.debug('Debug information', data: someData);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Show timestamp for each log
    ),
    level: _getLogLevel(), // Log level based on build mode
  );

  /// Get log level based on build mode
  /// In debug mode, show all logs. In release mode, only show warnings and errors.
  static Level _getLogLevel() {
    // You can also use kDebugMode from Flutter foundation
    // For now, we'll default to debug level
    // In production, you might want to set this to Level.warning
    return Level.debug;
  }

  /// Log a debug message
  /// Use for detailed information that is typically only interesting during development
  static void debug(
    String message, {
    Object? data,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.d('$prefix$message', error: data);
  }

  /// Log an info message
  /// Use for informational messages that highlight the progress of the application
  static void info(
    String message, {
    Object? data,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.i('$prefix$message', error: data);
  }

  /// Log a warning message
  /// Use for potentially harmful situations
  static void warning(
    String message, {
    Object? data,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.w('$prefix$message', error: data);
  }

  /// Log an error message
  /// Use for error events that might still allow the application to continue running
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.e(
      '$prefix$message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a fatal error message
  /// Use for very severe error events that might cause the application to abort
  static void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.f(
      '$prefix$message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a verbose message
  /// Use for very detailed information, typically of interest only when diagnosing problems
  static void verbose(
    String message, {
    Object? data,
    String? tag,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.t('$prefix$message', error: data);
  }

  /// Set the log level dynamically
  /// Note: To change the log level, you need to modify the _getLogLevel() method
  /// and recreate the logger instance. This is a limitation of the logger package.
  static void setLevel(Level level) {
    // Log level is set at initialization time
    // To change it, you would need to recreate the logger with a new level
    _logger.w('Log level change requested. Modify _getLogLevel() to change the level.');
  }

  /// Get the current log level
  /// Returns the level that was set during initialization
  static Level get level => _getLogLevel();
}

