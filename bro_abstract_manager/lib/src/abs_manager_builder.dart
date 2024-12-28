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

  /// Build the manager and call the [AbsWithLifeCycle.initLifeCycle] method.
  @mustCallSuper
  Future<Manager> build() async {
    final manager = managerFactory();
    await manager.initLifeCycle();
    return manager;
  }

  /// Get the dependencies of the manager.
  ///
  /// [Type] is the type of the dependencies and must be a subclass of [AbsWithLifeCycle].
  @mustCallSuper
  Iterable<Type> getDependencies();

  /// Dispose the [manager] and call the [AbsWithLifeCycle.disposeLifeCycle] method.
  Future<void> disposeManager(Manager manager) => manager.disposeLifeCycle();
}
