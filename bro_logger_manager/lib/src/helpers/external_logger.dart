// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_logger_manager/src/helpers/my_log_filter.dart';
import 'package:bro_logger_manager/src/helpers/my_log_printer.dart';
import 'package:bro_logger_manager/src/models/log_message.dart';
import 'package:bro_logger_manager/src/types/log_level_extension.dart';
import 'package:logger/logger.dart';

/// This is the implementation of the [MixinExternalLogger] using the [Logger] package.
class ExternalLogger with MixinExternalLogger {
  /// The [Logger] used to log the messages.
  final Logger _logger;

  /// Create the [ExternalLogger].
  ExternalLogger({
    required bool enabled,
    required LogsLevel level,
  }) : _logger = Logger(
          filter: MyLogFilter(
            enabled: enabled,
          ),
          level: LogLevelExtension.fromLogsLevel(level),
          output: ConsoleOutput(),
          printer: MyLogPrinter(),
        );

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
  @override
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  }) =>
      _logger.log(
        LogLevelExtension.fromLogsLevel(level),
        time: DateTime.now(),
        LogMessage(
          message: message,
          categories: categories,
        ),
      );

  /// {@macro bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  @override
  void logErrorWithException(
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) =>
      _logger.log(
        isFatal ? Level.fatal : Level.error,
        LogMessage(
          message: exception,
          categories: categories,
        ),
        stackTrace: stackTrace,
        time: DateTime.now(),
      );

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {
    await _logger.close();
  }
}
