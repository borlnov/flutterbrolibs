import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/models/config_file_error.dart';
import 'package:bro_config_manager/src/models/init_config_manager_model.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_all_configs_utility.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:flutter/foundation.dart';

abstract class AbsConfigBuilder<C extends AbstractConfigManager<C>> extends AbsManagerBuilder<C> {
  AbsConfigBuilder(super.managerFactory);
}

abstract class AbstractConfigManager<C extends AbstractConfigManager<C>> extends AbsWithLifeCycle
    with MixinManagerWithLogger {
  static const _logCategory = "config";

  late final InitConfigManagerModel _initConfigManagerModel;
  late final ConfigEnvironmentType envType;

  @override
  final String? logCategory;

  AbstractConfigManager() : logCategory = _logCategory;

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
      getLoggerHelper: () => logger,
    );
  }

  @protected
  Future<InitConfigManagerModel> getInitConfigManagerModel();
}
