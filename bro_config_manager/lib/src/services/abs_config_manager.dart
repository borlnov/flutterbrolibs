// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/models/errors/config_file_error.dart';
import 'package:bro_config_manager/src/models/init_config_manager_model.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_all_configs_utility.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:flutter/foundation.dart';

/// The abstract builder to create a [AbstractConfigManager].
abstract class AbsConfigBuilder<C extends AbstractConfigManager> extends AbsManagerBuilder<C> {
  /// Class constructor.
  const AbsConfigBuilder(super.managerFactory);
}

/// The abstract class to manage the configuration of the application.
abstract class AbstractConfigManager extends AbsWithLifeCycle with MixinManagerWithLogger {
  /// The logger category to use with the ConfigManager logger.
  static const _logCategory = "config";

  /// The model to initialize the ConfigManager.
  late final InitConfigManagerModel _initConfigManagerModel;

  /// The current application environment type.
  late final ConfigEnvironmentType envType;

  /// The logger category to use with the ConfigManager logger.
  @override
  final String? logCategory;

  /// Class constructor.
  AbstractConfigManager() : logCategory = _logCategory;

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    _initConfigManagerModel = await getInitConfigManagerModel();

    envType = ParseAllConfigsUtility.guessEnvType(
      defaultEnv:
          _initConfigManagerModel.defaultEnvironmentType ?? config_files_constants.defaultEnvType,
    );

    final jsonConfig = await ParseAllConfigsUtility.parseAllConfigs(
      configFolderPath: _initConfigManagerModel.configFolderPath ??
          config_files_constants.defaultConfigFolderPath,
      environmentType: envType,
      constEnvsValues: _initConfigManagerModel.constEnvsValues,
      logger: logger,
    );

    if (jsonConfig == null) {
      throw ConfigFileError();
    }

    ConfigCompanion.create(
      json: jsonConfig,
      loggerHelper: logger,
    );
  }

  /// This method returns the model to initialize the ConfigManager.
  @protected
  Future<InitConfigManagerModel> getInitConfigManagerModel();
}
