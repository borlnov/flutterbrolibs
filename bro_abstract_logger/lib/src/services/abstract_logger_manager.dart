// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/default_logger_helper.dart';
import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/foundation.dart';

/// This is an abstract builder for logger managers.
abstract class AbsLoggerBuilder<L extends AbstractLoggerManager> extends AbsManagerBuilder<L> {
  /// Class constructor.
  const AbsLoggerBuilder(super.managerFactory);
}

/// This is the abstract class for logger managers.
///
/// It provides a logger helper to manage the logs. The [loggerHelper] is always usable even if
/// [initLifeCycle] has not be called yet: at class start, it's created with the default print
/// logger. The [loggerHelper] is updated when calling the [getExternalLogger] method.
abstract class AbstractLoggerManager extends AbsWithLifeCycle {
  /// The external logger to use with the logger manager.
  late final MixinExternalLogger _externalLogger;

  /// The logger helper to use with the logger manager.
  final LoggerHelper loggerHelper;

  /// Class constructor.
  AbstractLoggerManager({
    bool printLogsByDefault = true,
  }) : loggerHelper = DefaultLoggerHelper(
          printLogs: printLogsByDefault,
        );

  /// Class constructor to create the manager from a logger helper.
  @protected
  AbstractLoggerManager.fromLoggerHelper({
    required this.loggerHelper,
  });

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    _externalLogger = await getExternalLogger();
    loggerHelper.updateLogger(_externalLogger);
  }

  /// {@template bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  /// This method returns the external logger to use with the logger manager.
  /// {@endtemplate}
  @protected
  Future<MixinExternalLogger> getExternalLogger();
}
