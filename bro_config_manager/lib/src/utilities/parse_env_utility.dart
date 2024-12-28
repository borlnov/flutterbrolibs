import 'dart:io';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/models/env_map_file_element.dart';
import 'package:bro_config_manager/src/models/env_map_value_element.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:bro_config_manager/src/utilities/parse_dot_env_file_utility.dart';
import 'package:bro_config_manager/src/utilities/parse_env_mapping_file_utility.dart';

abstract final class ParseEnvUtility {
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
