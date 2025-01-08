// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// This printer allows to print to multiple [LoggerHelper]s.
class MultiPrintLogger with MixinExternalLogger {
  /// The list of [LoggerHelper]s to log to.
  final List<LoggerHelper> _otherLoggers;

  /// Create a [MultiPrintLogger] with multiple [LoggerHelper]s.
  MultiPrintLogger({
    required List<LoggerHelper> loggers,
  }) : _otherLoggers = loggers;

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
  @override
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  }) {
    for (final logger in _otherLoggers) {
      logger.log(level, message);
    }
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
    for (final logger in _otherLoggers) {
      logger.logErrorWithException(
        exception,
        stackTrace: stackTrace,
        isFatal: isFatal,
      );
    }
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {}
}
