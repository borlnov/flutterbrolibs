// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/bro_config_manager.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/bro_logger_manager.dart';

/// Create a builder for the [ConfigManager]
class ConfigManagerBuilder extends AbsManagerBuilder<ConfigManager> {
  /// Create a builder for the [ConfigManager]
  ConfigManagerBuilder() : super(ConfigManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// This is the config manager to use for the tests.
class ConfigManager extends AbstractConfigManager with MixinLoggerConfigs {
  /// {@macro bro_config_manager.AbstractConfigManager.getInitConfigManagerModel}
  @override
  Future<InitConfigManagerModel> getInitConfigManagerModel() async => const InitConfigManagerModel(
        configFolderPath: "test/assets/config",
        defaultEnvironmentType: ConfigEnvironmentType.development,
      );
}
