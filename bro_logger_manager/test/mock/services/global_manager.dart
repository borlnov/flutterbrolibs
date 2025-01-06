// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/bro_logger_manager.dart';

import 'config_manager.dart';

/// This is the global manager to use for the tests.
class GlobalManager extends AbsGlobalManager {
  /// Get the instance of the global manager.
  ///
  /// Create the instance if it does not exist.
  static GlobalManager get instance => AbsGlobalManager.getCastedInstance(GlobalManager.new);

  /// {@macro abs_global_manager.AbsGlobalManager.registerManagers}
  @override
  void registerManagers(
      void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
          registerManager) {
    registerManager<ConfigManager, ConfigManagerBuilder>(ConfigManagerBuilder());
    registerManager<LoggerManager, LoggerManagerBuilder<ConfigManager>>(
        LoggerManagerBuilder<ConfigManager>());
  }
}
