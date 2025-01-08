// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter/foundation.dart';

/// A default logger that print logs to the console.
///
/// This uses the `print` function to log messages, only in debug mode.
///
/// This class is a singleton, because we want to have only one instance of the default print
/// logger.
class DefaultPrintLogger with MixinExternalLogger {
  /// This is the singleton instance of the default print logger.
  static DefaultPrintLogger? _instance;

  /// This is the getter of [_instance].
  static DefaultPrintLogger get instance {
    _instance ??= DefaultPrintLogger._();
    return _instance!;
  }

  /// This is the default prefix used to add a category to the log message.
  ///
  /// This is used to see when we use the [DefaultPrintLogger].
  static const String _defaultCategoryPrefix = "default";

  /// This is the minimum level to log messages.
  final LogsLevel minLevel;

  /// This is the private constructor of the default print logger.
  DefaultPrintLogger._() : minLevel = LogsLevel.trace;

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
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

    _debugPrint(LogFormatUtility.formatLogMessages(
      level: level,
      categories: [_defaultCategoryPrefix, ...categories],
      message: message,
    ));
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  @override
  void logErrorWithException(
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) {
    if (!_testIfLoggable(isFatal ? LogsLevel.fatal : LogsLevel.error)) {
      // We skip log because the error or fatal level is lower than the minLevel
      return;
    }

    _debugPrint(LogFormatUtility.formatLogMessages(
      level: isFatal ? LogsLevel.fatal : LogsLevel.error,
      categories: [_defaultCategoryPrefix, ...categories],
      exception: exception,
      stackTrace: stackTrace,
    ));
  }

  /// This method tests if a log is loggable thanks to the [minLevel].
  bool _testIfLoggable(LogsLevel level) => level.index >= minLevel.index;

  /// This uses the `print` function to log messages, only in debug mode.
  void _debugPrint(List<String> messages) {
    if (kDebugMode) {
      for (final message in messages) {
        print(message);
      }
    }
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {}
}
