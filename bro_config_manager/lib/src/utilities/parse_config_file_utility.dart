// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/global_parse_file_utility.dart';
import 'package:bro_yaml_utility/bro_yaml_utility.dart';

/// Utility class to parse the config files.
abstract final class ParseConfigFileUtility {
  /// Parse all the config files and merge them together.
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the merged config values or null if an error occurred.
  ///
  /// The config files are parsed in the following order:
  /// - default.yaml
  /// - [environmentType].yaml
  /// - local.yaml
  static Future<Map<String, dynamic>?> parseConfigFiles({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    LoggerHelper? logger,
  }) async {
    final defaultConfig = await GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: config_files_constants.defaultConfigFileName,
      logger: logger,
    );

    final envConfig = await GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: environmentType.fileBaseName,
      logger: logger,
    );

    final localConfig = await GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: config_files_constants.localConfigFileName,
      logger: logger,
    );

    if (!defaultConfig.success || !envConfig.success || !localConfig.success) {
      return null;
    }

    final tmpEnvConfig = JsonUtility.mergeJson(
      defaultConfig.value,
      envConfig.value,
      logger: logger,
    );

    return JsonUtility.mergeJson(
      tmpEnvConfig,
      localConfig.value,
      logger: logger,
    );
  }
}
