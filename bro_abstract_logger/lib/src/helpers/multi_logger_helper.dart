// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/types/logs_level.dart';

/// A [LoggerHelper] that logs to multiple [LoggerHelper]s.
class MultiLoggerHelper extends LoggerHelper {
  /// The list of [LoggerHelper]s to log to.
  final List<LoggerHelper> _loggers;

  /// Create a [MultiLoggerHelper] with multiple [LoggerHelper]s.
  MultiLoggerHelper({
    required List<LoggerHelper> loggers,
  })  : _loggers = loggers,
        super.subLogger(
          categories: [],
          minLevel: null,
        );

  /// {@macro bro_abstract_logger.LoggerHelper.log}
  @override
  void log(LogsLevel level, String message) {
    for (final logger in _loggers) {
      logger.log(level, message);
    }
  }

  /// {@macro bro_abstract_logger.LoggerHelper.logErrorWithException}
  @override
  void logErrorWithException(
    dynamic exception, {
    bool isFatal = false,
    StackTrace? stackTrace,
  }) {
    for (final logger in _loggers) {
      logger.logErrorWithException(
        exception,
        isFatal: isFatal,
        stackTrace: stackTrace,
      );
    }
  }
}
