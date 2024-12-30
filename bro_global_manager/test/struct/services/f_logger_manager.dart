// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

import '../helpers/test_print_logger.dart';
import '../mixins/mixin_life_cycle_status.dart';
import 'b_manager.dart';

/// This is the builder to create the [CLoggerManager].
class FLoggerBuilder extends AbsLoggerBuilder<FLoggerManager> {
  /// Create the [FLoggerBuilder].
  const FLoggerBuilder() : super(FLoggerManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [BManager];
}

/// This is the manager used to test the logging system.
class FLoggerManager extends AbstractLoggerManager with MixinLifeCycleStatus {
  /// Create the [FLoggerManager].
  FLoggerManager() : super();

  /// Create the [FLoggerManager] from the [loggerHelper].
  FLoggerManager.fromLoggerHelper({
    required super.loggerHelper,
  }) : super.fromLoggerHelper();

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async => TestPrintLogger();
}
