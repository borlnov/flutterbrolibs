// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_abstract_logger/src/helpers/multi_logger_helper.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/widgets.dart';

/// This is the abstract builder for a multi logger manager.
///
/// The class manages the creation of the linked logger managers.
///
/// If you use [AbsMultiLoggerBuilder], don't create the linked logger managers by yourself, use
/// the [AbsMultiLoggerBuilder] to create them.
abstract class AbsMultiLoggerBuilder<L extends AbstractMultiLoggerManager>
    extends AbsManagerBuilder<L> {
  /// The list of loggers builders.
  final List<AbsLoggerBuilder> _loggersBuilders;

  /// Class constructor.
  ///
  /// {@template bro_abstract_logger.AbsMultiLoggerBuilder.constructor.params}
  /// The [mainManagerFactory] is the factory to create the multi logger manager.
  /// The [loggersBuilders] is the list of builders to create the linked logger managers.
  /// {@endtemplate}
  AbsMultiLoggerBuilder({
    required L Function(List<AbstractLoggerManager> loggerManager) mainManagerFactory,
    required List<AbsLoggerBuilder> loggersBuilders,
  })  : _loggersBuilders = loggersBuilders,
        super(() => _multiFactory(
              mainManagerFactory: mainManagerFactory,
              loggersBuilders: loggersBuilders,
            ));

  /// Create the multi logger manager.
  ///
  /// {@macro bro_abstract_logger.AbsMultiLoggerBuilder.constructor.params}
  static L _multiFactory<L extends AbstractMultiLoggerManager>({
    required L Function(List<AbstractLoggerManager> loggerManager) mainManagerFactory,
    required List<AbsLoggerBuilder> loggersBuilders,
  }) {
    final managers = <AbstractLoggerManager>[];
    for (final builder in loggersBuilders) {
      managers.add(builder.managerFactory());
    }

    return mainManagerFactory(managers);
  }

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  @mustCallSuper
  Iterable<Type> getDependencies() =>
      _loggersBuilders.expand((element) => element.getDependencies());
}

/// This is the abstract class for a multi logger manager.
///
/// The class manages multiple logger managers. It uses the [MultiLoggerHelper] to log messages,
/// the helper logs to all the linked logger managers.
abstract class AbstractMultiLoggerManager extends AbstractLoggerManager {
  /// The list of linked logger managers.
  final List<AbstractLoggerManager> _loggersManager;

  /// Class constructor.
  AbstractMultiLoggerManager({
    required List<AbstractLoggerManager> loggersManager,
  })  : _loggersManager = loggersManager,
        super.fromLoggerHelper(
          loggerHelper: MultiLoggerHelper(
            loggers: loggersManager.map((manager) => manager.loggerHelper).toList(),
          ),
        );

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await Future.wait(_loggersManager.map((manager) => manager.initLifeCycle()));

    return super.initLifeCycle();
  }

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initAfterViewBuilt}
  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    await Future.wait(_loggersManager.map((manager) => manager.initAfterViewBuilt(context)));

    return super.initAfterViewBuilt(context);
  }

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.disposeLifeCycle}
  @override
  Future<void> disposeLifeCycle() async {
    await Future.wait(_loggersManager.map((manager) => manager.disposeLifeCycle()));

    return super.disposeLifeCycle();
  }
}
