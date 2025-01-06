// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/src/helpers/external_logger.dart';
import 'package:bro_logger_manager/src/mixins/mixin_logger_configs.dart';

/// This class is the builder to create the [LoggerManager].
class LoggerManagerBuilder<C extends MixinLoggerConfigs> extends AbsLoggerBuilder<LoggerManager> {
  /// Create the [LoggerManagerBuilder].
  ///
  /// {@macro bro_abstract_logger.AbstractLoggerManager.registerFlutterNonManagedErrorsAttention}
  LoggerManagerBuilder({
    bool registerFlutterNonManagedErrors = true,
  }) : super(
          () => LoggerManager(
            configGetter: globalGetManager<C>,
            registerFlutterNonManagedErrors: registerFlutterNonManagedErrors,
          ),
        );

  @override
  Iterable<Type> getDependencies() => [C];
}

/// This is an implementation of the [AbstractLoggerManager] with the Logger library.
class LoggerManager extends AbstractLoggerManager {
  /// Get the config manager linked to this logger manager.
  final MixinLoggerConfigs Function() _configGetter;

  /// Class constructor.
  LoggerManager({
    required MixinLoggerConfigs Function() configGetter,
    required super.registerFlutterNonManagedErrors,
  }) : _configGetter = configGetter;

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async {
    final config = _configGetter();
    return ExternalLogger(
      enabled: config.consoleLogEnabled.load(),
      level: config.consoleLogLevel.load(),
    );
  }
}
