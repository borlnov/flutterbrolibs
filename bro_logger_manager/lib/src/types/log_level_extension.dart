// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:logger/logger.dart';

/// Extension for the [Level] class to convert it to a [LogsLevel] and vice versa.
extension LogLevelExtension on Level {
  /// Convert a [LogsLevel] to a [Level].
  static Level fromLogsLevel(LogsLevel level) => switch (level) {
        LogsLevel.trace => Level.trace,
        LogsLevel.debug => Level.debug,
        LogsLevel.info => Level.info,
        LogsLevel.warn => Level.warning,
        LogsLevel.error => Level.error,
        LogsLevel.fatal => Level.fatal,
        LogsLevel.none => Level.off,
      };

  /// Convert a [Level] to a [LogsLevel].
  LogsLevel get logsLevel => switch (this) {
        Level.trace || Level.all || Level.verbose || Level.wtf => LogsLevel.trace,
        Level.debug => LogsLevel.debug,
        Level.info => LogsLevel.info,
        Level.warning => LogsLevel.warn,
        Level.error => LogsLevel.error,
        Level.fatal => LogsLevel.fatal,
        Level.off || Level.nothing => LogsLevel.none,
      };
}
