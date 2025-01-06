// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:logger/logger.dart';

/// This class is a custom log filter that allows to filter logs based on the log level.
class MyLogFilter extends LogFilter {
  /// This property indicates if the filter is enabled.
  final bool enabled;

  /// Create the [MyLogFilter].
  MyLogFilter({
    required this.enabled,
  });

  /// Returns true if the log should be logged.
  @override
  bool shouldLog(LogEvent event) {
    if (!enabled) {
      return false;
    }

    return event.level.index >= level!.index;
  }
}
