// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/default_print_logger.dart';
import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/helpers/void_print_logger.dart';

/// This is a default logger helper that uses one of the default print loggers.
class DefaultLoggerHelper extends LoggerHelper {
  /// Create a default logger helper.
  ///
  /// If [printLogs] is true, the logger will use [DefaultPrintLogger.instance].
  /// Otherwise, it will use [VoidPrintLogger.instance] (which print nothing).
  DefaultLoggerHelper({
    bool printLogs = true,
  }) : super(
          logger: printLogs ? DefaultPrintLogger.instance : VoidPrintLogger.instance,
        );
}
