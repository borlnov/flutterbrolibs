// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/bro_config_manager.dart';

/// This mixin contains the logger configs.
mixin MixinLoggerConfigs on AbstractConfigManager {
  /// Enable or disable the logs to console.
  final consoleLogEnabled = SimpleConfigVar.jsonPathList(
    jsonPathList: ['logger', 'console', 'enabled'],
    defaultValue: true,
  );

  /// The console log level of the logger.
  final consoleLogLevel = ConfigVar.jsonPathList(
    jsonPathList: ['logger', 'console', 'level'],
    defaultValue: LogsLevel.warn,
    converter: LogsLevel.parseFromString,
  );
}
