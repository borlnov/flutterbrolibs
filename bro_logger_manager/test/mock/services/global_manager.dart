// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/bro_logger_manager.dart';

import 'config_manager.dart';

class GlobalManager extends AbsGlobalManager {
  static GlobalManager get instance => AbsGlobalManager.getCastedInstance(GlobalManager.new);

  @override
  void registerManagers(
      void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
          registerManager) {
    registerManager<ConfigManager, ConfigManagerBuilder>(ConfigManagerBuilder());
    registerManager<LoggerManager, LoggerManagerBuilder<ConfigManager>>(
        LoggerManagerBuilder<ConfigManager>());
  }
}
