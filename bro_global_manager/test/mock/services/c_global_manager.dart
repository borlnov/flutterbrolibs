// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/src/abs_manager_builder.dart';
import 'package:bro_abstract_manager/src/abs_with_life_cycle.dart';
import 'package:bro_global_manager/bro_global_manager.dart';

import 'f_logger_manager.dart';
import 'g_manager.dart';

/// A global manager for testing the mixin manager with logger.
class CGlobalManager extends AbsGlobalManager {
  /// Create the [CGlobalManager].
  static CGlobalManager get instance =>
      AbsGlobalManager.getCastedInstance<CGlobalManager>(CGlobalManager.new);

  /// {@macro abs_global_manager.AbsGlobalManager.registerManagers}
  @override
  void registerManagers(
    void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
        registerManager,
  ) {
    registerManager<GManager, GManagerBuilder>(const GManagerBuilder());
    registerManager<FLoggerManager, FLoggerBuilder>(const FLoggerBuilder());
  }
}
