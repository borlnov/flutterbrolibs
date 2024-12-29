// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/models/env_map_file_element.dart';
import 'package:bro_config_manager/src/models/env_map_value_element.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_dot_env_file_utility.dart';
import 'package:bro_config_manager/src/utilities/parse_env_mapping_file_utility.dart';

/// The utility class to parse the environment configuration.
abstract final class ParseEnvUtility {
  /// Parse the environment configuration: the dot env files and the environment mapping file.
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// [constEnvsValues] is the constant environment values passed when building the app.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the parsed environment configuration or null if an error occurred.
  static Future<Map<String, dynamic>?> parseEnvConfig({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    required Map<String, String> constEnvsValues,
    LoggerHelper? logger,
  }) async {
    final envMapFileElements = ParseEnvMappingFileUtility.parseMappingFile(
      configFolderPath: configFolderPath,
      logger: logger,
    );

    if (envMapFileElements == null) {
      return null;
    }

    final envMapValues = await _parseMapEnv(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      envMapFileElements: envMapFileElements,
      constEnvsValues: constEnvsValues,
      logger: logger,
    );

    if (envMapValues == null) {
      return null;
    }

    return ParseEnvMappingFileUtility.transformEnvMapValuesToJson(
      envValues: envMapValues,
      logger: logger,
    );
  }

  /// Use the [envMapFileElements] to parse the environment values and return a list of
  /// [EnvMapValueElement].
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// [constEnvsValues] is the constant environment values passed when building the app.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the parsed elements or null if an error occurred.
  static Future<List<EnvMapValueElement>?> _parseMapEnv({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    required List<EnvMapFileElement> envMapFileElements,
    required Map<String, String> constEnvsValues,
    required LoggerHelper? logger,
  }) async {
    final allEnvValues = await _getEnvValues(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      constEnvsValues: constEnvsValues,
      logger: logger,
    );

    if (allEnvValues == null) {
      return null;
    }

    final envValues = <EnvMapValueElement>[];
    for (final element in envMapFileElements) {
      final value = allEnvValues[element.envKey];
      if (value == null) {
        // We don't have the value for this element; therefore, we skip it
        continue;
      }

      final envValue = EnvMapValueElement.fromEnvMapElement(
        envMapElement: element,
        value: value,
        logger: logger,
      );

      if (envValue == null) {
        return null;
      }

      envValues.add(envValue);
    }

    return envValues;
  }

  /// Get all the environment values from the dot env files and the platform environment.
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// [constEnvsValues] is the constant environment values passed when building the app.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the environment values or null if an error occurred.
  ///
  /// The values are merged in the following order:
  /// - The platform environment values
  /// - The dot env files values
  /// - The constant values
  static Future<Map<String, String>?> _getEnvValues({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    required Map<String, String> constEnvsValues,
    required LoggerHelper? logger,
  }) async {
    // We first get the platform environment values
    final allEnvValues = Map<String, String>.from(Platform.environment);

    // Then we get the dot env values from dot env files
    final dotEnvValues = await ParseDotEnvFileUtility.parseDotEnvFiles(
      configFolderPath: configFolderPath,
      environmentType: environmentType,
      logger: logger,
    );

    if (dotEnvValues == null) {
      return null;
    }

    allEnvValues.addAll(dotEnvValues);

    // Finally we add the const values which are the values passed to the app when building
    allEnvValues.addAll(constEnvsValues);

    return allEnvValues;
  }
}
