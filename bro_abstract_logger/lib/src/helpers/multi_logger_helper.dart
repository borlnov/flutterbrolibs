// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/helpers/multi_print_logger.dart';

/// A [LoggerHelper] that logs to multiple [LoggerHelper]s.
class MultiLoggerHelper extends LoggerHelper {
  /// The list of [LoggerHelper]s to log to.
  final List<LoggerHelper> loggers;

  /// Create a [MultiLoggerHelper] with multiple [LoggerHelper]s.
  MultiLoggerHelper({
    required this.loggers,
  }) : super(
          logger: MultiPrintLogger(loggers: loggers),
        );
}
