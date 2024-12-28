import 'package:bro_abstract_logger/src/types/logs_level.dart';

mixin MixinExternalLogger {
  void trace(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.trace,
        message,
        categories: categories,
      );

  void debug(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.debug,
        message,
        categories: categories,
      );

  void info(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.info,
        message,
        categories: categories,
      );

  void warn(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.warn,
        message,
        categories: categories,
      );

  void error(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.error,
        message,
        categories: categories,
      );

  void fatal(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.fatal,
        message,
        categories: categories,
      );

  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  });

  void logErrorWithException(
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  });

  Future<void> dispose();
}
