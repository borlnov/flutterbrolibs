import 'dart:io';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/global_parse_file_utility.dart';
import 'package:bro_json_utility/bro_json_utility.dart';

abstract final class ParseConfigFileUtility {
  static Map<String, dynamic>? parseConfigFiles({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    LoggerHelper? logger,
  }) {
    final defaultConfig = GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: config_files_constants.defaultConfigFileName,
      logger: logger,
    );

    final envConfig = GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: environmentType.fileName,
      logger: logger,
    );

    final localConfig = GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: config_files_constants.localConfigFileName,
      logger: logger,
    );

    if (!defaultConfig.success || !envConfig.success || !localConfig.success) {
      return null;
    }

    final tmpEnvConfig = JsonUtility.mergeNullableJson(
      defaultConfig.value,
      envConfig.value,
      logger: logger,
    );

    return JsonUtility.mergeNullableJson(
      tmpEnvConfig,
      localConfig.value,
      logger: logger,
    );
  }
}
