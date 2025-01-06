// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/bro_config_manager.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/bro_logger_manager.dart';

///
class ConfigManagerBuilder extends AbsManagerBuilder<ConfigManager> {
  ConfigManagerBuilder() : super(ConfigManager.new);

  @override
  Iterable<Type> getDependencies() => [];
}

class ConfigManager extends AbstractConfigManager with MixinLoggerConfigs {
  @override
  Future<InitConfigManagerModel> getInitConfigManagerModel() async => const InitConfigManagerModel(
        configFolderPath: "test/assets/config",
        defaultEnvironmentType: ConfigEnvironmentType.development,
      );
}
