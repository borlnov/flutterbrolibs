import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_logger/src/types/logs_level.dart';
import 'package:flutter/foundation.dart';

class DefaultPrintLogger with MixinExternalLogger {
  static DefaultPrintLogger? _instance;

  static DefaultPrintLogger get instance {
    _instance ??= DefaultPrintLogger._();
    return _instance!;
  }

  static const String _defaultCategorySeparator = "/";

  static const String _defaultCategoryPrefix = "default";

  final LogsLevel minLevel;

  DefaultPrintLogger._() : minLevel = kReleaseMode ? LogsLevel.error : LogsLevel.trace;

  @override
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  }) {
    if (!_testIfLoggable(level)) {
      // We skip log because the level is lower than the minLevel
      return;
    }

    print(_formatMessage(
      level: level,
      categories: categories,
      message: message,
    ));
  }

  @override
  void logErrorWithException(
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) {
    if (!_testIfLoggable(isFatal ? LogsLevel.fatal : LogsLevel.error)) {
      // We skip log because the error or fatal level is lower than the minLevel
      return;
    }

    print(_formatMessage(
      level: isFatal ? LogsLevel.fatal : LogsLevel.error,
      categories: categories,
      message: exception,
    ));
    if (stackTrace != null) {
      print(_formatMessage(
        level: isFatal ? LogsLevel.fatal : LogsLevel.error,
        categories: categories,
        message: stackTrace,
      ));
    }
  }

  bool _testIfLoggable(LogsLevel level) => level.index >= minLevel.index;

  String _formatMessage({
    required LogsLevel level,
    required List<String> categories,
    required dynamic message,
  }) =>
      "${DateTime.now().toUtc().toIso8601String()} - [${level.name.toLowerCase()}] [${[
        _defaultCategoryPrefix,
        ...categories,
      ].join(_defaultCategorySeparator)}]: $message";

  @override
  Future<void> dispose() async {}
}
