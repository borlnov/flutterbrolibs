// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/widgets.dart';

/// This is an abstract class to build a manager with a lifecycle.
///
/// This is used to build managers for get it package.
abstract class AbsManagerBuilder<Manager extends AbsWithLifeCycle> {
  /// The factory used to create the manager.
  final Manager Function() managerFactory;

  /// Class constructor.
  const AbsManagerBuilder(this.managerFactory);

  /// {@template bro_abstract_manager.AbsManagerBuilder.build}
  /// Build the manager and call the [AbsWithLifeCycle.initLifeCycle] method.
  /// {@endtemplate}
  @mustCallSuper
  Future<Manager> build({
    Manager? managerToInit,
  }) async {
    final manager = managerToInit ?? managerFactory();
    await manager.initLifeCycle();
    return manager;
  }

  /// {@template bro_abstract_manager.AbsManagerBuilder.getDependencies}
  /// Get the dependencies of the manager.
  ///
  /// [Type] is the type of the dependencies and must be a subclass of [AbsWithLifeCycle].
  /// {@endtemplate}
  @mustCallSuper
  Iterable<Type> getDependencies();

  /// Dispose the [manager] and call the [AbsWithLifeCycle.disposeLifeCycle] method.
  Future<void> disposeManager(Manager manager) => manager.disposeLifeCycle();
}
