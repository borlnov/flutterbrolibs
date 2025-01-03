// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/src/abs_manager_builder.dart';
import 'package:bro_abstract_manager/src/abs_with_life_cycle.dart';
import 'package:bro_global_manager/bro_global_manager.dart';

import 'd_manager.dart';
import 'e_manager.dart';

/// A non-working global manager for the test. The [EManager] and [DManager] are interdependent.
class BGlobalManager extends AbsGlobalManager {
  /// {@macro abs_global_manager.AbsGlobalManager.registerManagers}
  @override
  void registerManagers(
    void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
        registerManager,
  ) {
    registerManager<EManager, EManagerBuilder>(const EManagerBuilder());
    registerManager<DManager, DManagerBuilder>(const DManagerBuilder());
  }
}
