// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_config_file_utility.dart';
import 'package:bro_config_manager/src/utilities/parse_env_utility.dart';

/// Utility class to parse all the config files, dot files and environment values and merge them
/// together.
abstract final class ParseAllConfigsUtility {
  /// Parse all the config files, dot files and environment values and merge them together.
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// [constEnvsValues] is the constant environment values passed when building the app.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the merged config values or null if an error occurred.
  ///
  /// The config files values are parsed in the following order:
  /// - default.yaml
  /// - [environmentType].yaml
  /// - local.yaml
  /// - .env
  /// - default.env
  /// - [environmentType].env
  /// - local.env
  /// - building environment values
  static Future<Map<String, dynamic>?> parseAllConfigs({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    required Map<String, String> constEnvsValues,
    LoggerHelper? logger,
  }) async {
    final configValues = await ParseConfigFileUtility.parseConfigFiles(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      logger: logger,
    );

    if (configValues == null) {
      return null;
    }

    final mergedConfigValues = await ParseEnvUtility.mergeWithEnvConfig(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      constEnvsValues: constEnvsValues,
      configValues: configValues,
      logger: logger,
    );

    return mergedConfigValues;
  }

  /// Guess the environment type from the environment variables passed when building the app.
  static ConfigEnvironmentType guessEnvType({
    required ConfigEnvironmentType defaultEnv,
  }) {
    String? value;
    // We use the const constructor to be sure to get the environment value passed when building
    // ignore: do_not_use_environment
    if (const bool.hasEnvironment(config_files_constants.envKeyName)) {
      // We use the const constructor to be sure to get the environment value passed when building
      // ignore: do_not_use_environment
      value = const String.fromEnvironment(config_files_constants.envKeyName);
    }

    return ConfigEnvironmentType.fromString(value) ?? defaultEnv;
  }
}
