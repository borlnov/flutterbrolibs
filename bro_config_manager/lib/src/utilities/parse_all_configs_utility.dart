import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_config_file_utility.dart';
import 'package:bro_config_manager/src/utilities/parse_env_utility.dart';
import 'package:bro_json_utility/bro_json_utility.dart';

abstract final class ParseAllConfigsUtility {
  static Future<Map<String, dynamic>?> parseAllConfigs({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    required Map<String, String> constEnvsValues,
    LoggerHelper? logger,
  }) async {
    final configValues = ParseConfigFileUtility.parseConfigFiles(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      logger: logger,
    );

    if (configValues == null) {
      return null;
    }

    final envConfigValues = await ParseEnvUtility.parseEnvConfig(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      constEnvsValues: constEnvsValues,
      logger: logger,
    );

    if (envConfigValues == null) {
      return null;
    }

    return JsonUtility.mergeJson(configValues, envConfigValues);
  }

  static ConfigEnvironmentType guessEnvType({
    required ConfigEnvironmentType defaultEnv,
  }) {
    String? value;
    if (const bool.hasEnvironment(config_files_constants.envKeyLowName)) {
      value = const String.fromEnvironment(config_files_constants.envKeyLowName);
    } else if (const bool.hasEnvironment(config_files_constants.envKeyName)) {
      value = const String.fromEnvironment(config_files_constants.envKeyName);
    }

    return ConfigEnvironmentType.fromString(value) ?? defaultEnv;
  }
}
