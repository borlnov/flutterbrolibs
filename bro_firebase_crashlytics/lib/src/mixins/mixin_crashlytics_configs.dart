// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/bro_config_manager.dart';

/// Contains the config variables for the crashlytics manager.
mixin MixinCrashlyticsConfigs on AbstractConfigManager {
  /// Says if the crashlytics is enabled or not.
  final crashlyticsEnabled = SimpleConfigVar<bool>.jsonPathList(
    jsonPathList: ["firebase", "crashlytics", "enabled"],
    defaultValue: false,
  );

  /// The number of last logs to include in the crash report.
  final includeLastLogsNb = SimpleConfigVar<int>.jsonPathList(
    jsonPathList: ["firebase", "crashlytics", "includeLastLogs", "logsNb"],
  );

  /// The minimum level of logs to include in the crash report.
  final includeLastLogsMinLevel = ConfigVar.jsonPathList(
    jsonPathList: ["firebase", "crashlytics", "includeLastLogs", "minLevel"],
    converter: LogsLevel.parseFromString,
    defaultValue: LogsLevel.warn,
  );
}
