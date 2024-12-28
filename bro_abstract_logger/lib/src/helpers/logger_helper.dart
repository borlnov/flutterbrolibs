import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_logger/src/types/logs_level.dart';

class LoggerHelper {
  final MixinExternalLogger _logger;

  final List<String> categories;

  final LogsLevel? minLevel;

  LoggerHelper({
    required MixinExternalLogger logger,
    String? category,
    this.minLevel,
  })  : _logger = logger,
        categories = [
          if (category != null) category,
        ];

  const LoggerHelper._subLogger({
    required MixinExternalLogger logger,
    required this.categories,
    required this.minLevel,
  }) : _logger = logger;

  LoggerHelper createSubLogger({
    String? category,
    LogsLevel? minLevel,
  }) =>
      LoggerHelper._subLogger(
        logger: _logger,
        categories: [
          ...categories,
          if (category != null) category,
        ],
        minLevel: minLevel ?? this.minLevel,
      );

  void trace(String message) => log(
        LogsLevel.trace,
        message,
      );

  void debug(String message) => log(
        LogsLevel.debug,
        message,
      );

  void info(String message) => log(
        LogsLevel.info,
        message,
      );

  void warn(String message) => log(
        LogsLevel.warn,
        message,
      );

  void error(String message) => log(
        LogsLevel.error,
        message,
      );

  void fatal(String message) => log(
        LogsLevel.fatal,
        message,
      );

  void log(LogsLevel level, String message) {
    if (!_testIfLoggable(level)) {
      // We skip log because the level is lower than the minLevel
      return;
    }

    _logger.log(
      level,
      message,
      categories: categories,
    );
  }

  void logErrorWithException(
    dynamic exception, {
    bool isFatal = false,
    StackTrace? stackTrace,
  }) {
    if (!_testIfLoggable(isFatal ? LogsLevel.fatal : LogsLevel.error)) {
      // We skip log because the error level is lower than the minLevel
      return;
    }

    _logger.logErrorWithException(
      exception,
      isFatal: isFatal,
      stackTrace: stackTrace,
      categories: categories,
    );
  }

  bool _testIfLoggable(LogsLevel level) => minLevel == null || level.index >= minLevel!.index;
}
