// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';

import '../mixins/mixin_life_cycle_status.dart';

/// Build a new [GManager].
class GManagerBuilder extends AbsManagerBuilder<GManager> {
  /// Create a new [GManagerBuilder].
  const GManagerBuilder() : super();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.create}
  @override
  GManager create() => GManager();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// A simple manager for the test.
class GManager extends AbsWithLifeCycle with MixinLifeCycleStatus, MixinManagerWithLogger {
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    logger.info('GManager is initialized');
  }
}
