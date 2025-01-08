// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/bro_config_manager.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/src/helpers/external_logger.dart';
import 'package:bro_logger_manager/src/mixins/mixin_logger_configs.dart';

/// This class is the builder to create the [LoggerManager].
class LoggerManagerBuilder<C extends MixinLoggerConfigs> extends AbsLoggerBuilder<LoggerManager> {
  /// This is the flag to indicate if the [LoggerManager] should register the Flutter non managed
  /// errors.
  ///
  /// {@macro bro_abstract_logger.AbstractLoggerManager.registerFlutterNonManagedErrorsAttention}
  final bool registerFlutterNonManagedErrors;

  /// Create the [LoggerManagerBuilder].
  const LoggerManagerBuilder({
    this.registerFlutterNonManagedErrors = true,
  }) : super();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.create}
  @override
  LoggerManager create() => LoggerManager(
        configGetter: globalGetManager<C>,
        registerFlutterNonManagedErrors: registerFlutterNonManagedErrors,
      );

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [C];
}

/// This is an implementation of the [AbstractLoggerManager] with the Logger library.
///
/// To use this manager, you have to add the [MixinLoggerConfigs] to your implementation of
/// the [AbstractConfigManager].
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
