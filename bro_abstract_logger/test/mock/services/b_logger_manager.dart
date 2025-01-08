// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

import '../helpers/test_print_logger.dart';

/// This is the builder to create the [BLoggerManager].
class BLoggerBuilder extends AbsLoggerBuilder<BLoggerManager> {
  @override
  BLoggerManager create() => BLoggerManager();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// This is the manager used to test the logging system.
class BLoggerManager extends AbstractLoggerManager {
  /// Create the [BLoggerManager].
  BLoggerManager({
    super.registerFlutterNonManagedErrors,
  }) : super();

  /// Create the [BLoggerManager] from the [loggerHelper].
  BLoggerManager.fromLoggerHelper({
    required super.loggerHelper,
    super.registerFlutterNonManagedErrors,
  }) : super.fromLoggerHelper();

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async => TestPrintLogger();
}
