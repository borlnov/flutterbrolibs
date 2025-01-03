// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

import '../helpers/test_print_logger.dart';

/// This is the builder to create the [ALoggerManager].
class ALoggerBuilder extends AbsLoggerBuilder<ALoggerManager> {
  /// Create the [ALoggerBuilder].
  ALoggerBuilder() : super(ALoggerManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// This is the manager used to test the logging system.
class ALoggerManager extends AbstractLoggerManager {
  /// Create the [ALoggerManager].
  ALoggerManager() : super();

  /// Create the [ALoggerManager] from the [loggerHelper].
  ALoggerManager.fromLoggerHelper({
    required super.loggerHelper,
  }) : super.fromLoggerHelper();

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async => TestPrintLogger();
}
