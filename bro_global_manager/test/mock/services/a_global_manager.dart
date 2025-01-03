// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/src/abs_manager_builder.dart';
import 'package:bro_abstract_manager/src/abs_with_life_cycle.dart';
import 'package:bro_global_manager/bro_global_manager.dart';

import 'a_manager.dart';
import 'b_manager.dart';
import 'c_logger_manager.dart';

/// A working global manager for the test.
class AGlobalManager extends AbsGlobalManager {
  /// {@macro abs_global_manager.AbsGlobalManager.registerManagers}
  @override
  void registerManagers(
    void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
        registerManager,
  ) {
    registerManager<AManager, AManagerBuilder>(const AManagerBuilder());
    registerManager<BManager, BManagerBuilder>(const BManagerBuilder());
    registerManager<CLoggerManager, CLoggerBuilder>(const CLoggerBuilder());
  }
}
