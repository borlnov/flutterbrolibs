// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/models/env_map_file_element.dart';
import 'package:bro_config_manager/src/models/env_map_value_element.dart';
import 'package:bro_config_manager/src/utilities/global_parse_file_utility.dart';

/// Utility class to parse the env mapping file.
abstract final class ParseEnvMappingFileUtility {
  /// Merge the environment mapping values with the config values.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the JSON object or null if an error occurred.
  static Map<String, dynamic>? mergeWithEnvMapValues({
    required List<EnvMapValueElement> envValues,
    required Map<String, dynamic> configValues,
    LoggerHelper? logger,
  }) {
    final json = Map<String, dynamic>.from(configValues);
    var tmpJson = json;
    for (final envValue in envValues) {
      final jsonPath = envValue.jsonPath;
      for (var idx = 0; idx < jsonPath.length; ++idx) {
        final key = jsonPath[idx];
        if (idx == jsonPath.length - 1) {
          tmpJson[key] = envValue.value;
        } else {
          var tmpValue = tmpJson[key];

          if (tmpValue == null) {
            tmpJson[key] = <String, dynamic>{};
            tmpValue = tmpJson[key];
          } else if (tmpValue is! Map<String, dynamic>) {
            logger?.warn("Env map parsing: failed to parse the element: $envValue, the json path "
                "is not valid, the key: $key is used for a value and a map");
            return null;
          }

          tmpJson = tmpValue as Map<String, dynamic>;
        }
      }

      tmpJson = json;
    }

    return json;
  }

  /// Parse the mapping file and return the parsed elements.
  ///
  /// [configFolderPath] is the path to the folder containing the config files.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the parsed elements or null if an error occurred.
  static Future<List<EnvMapFileElement>?> parseMappingFile({
    required String configFolderPath,
    LoggerHelper? logger,
  }) async {
    final envMapFile = await GlobalParseFileUtility.parseConfigFile(
      configFolderPath: configFolderPath,
      fileName: config_files_constants.envMapFileName,
      logger: logger,
    );

    if (!envMapFile.success) {
      return null;
    }

    if (envMapFile.value == null) {
      return const [];
    }

    return _parseElements(
      envMapFile: envMapFile.value!,
      currentJsonPath: const [],
      logger: logger,
    );
  }

  /// Parse the elements of the mapping file. This is a recursive function.
  ///
  /// [envMapFile] is the mapping file to parse.
  ///
  /// [currentJsonPath] is the current path in the JSON file.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the parsed elements or null if an error occurred.
  static List<EnvMapFileElement>? _parseElements({
    required Map<String, dynamic> envMapFile,
    required List<String> currentJsonPath,
    required LoggerHelper? logger,
  }) {
    final elements = <EnvMapFileElement>[];

    for (final entry in envMapFile.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key == EnvMapFileElement.attrNameKey || key == EnvMapFileElement.attrFormatKey) {
        final parsedElement = EnvMapFileElement.fromComplexType(
          json: envMapFile,
          currentJsonPath: currentJsonPath,
        );

        if (parsedElement == null) {
          logger?.warn("Env map parsing: failed to parse the element: $envMapFile, it's not a "
              "valid element");
          return null;
        }

        elements.add(parsedElement);
        // Useless to go forward, we already parsed the element
        break;
      }

      final newJsonPath = List<String>.from(currentJsonPath);
      newJsonPath.add(key);

      if (value is String) {
        final parsedElement = EnvMapFileElement.fromStringType(
          envKey: value,
          currentJsonPath: newJsonPath,
        );

        if (parsedElement == null) {
          logger?.warn("Env map parsing: failed to parse the element: $envMapFile, it's not a "
              "valid element");
          return null;
        }

        elements.add(parsedElement);
      } else if (value is Map<String, dynamic>) {
        final parsedElements = _parseElements(
          envMapFile: value,
          currentJsonPath: newJsonPath,
          logger: logger,
        );

        if (parsedElements == null) {
          return null;
        }

        elements.addAll(parsedElements);
      } else {
        logger?.warn("Env map parsing: failed to parse the element: $envMapFile, the value it's "
            "not a valid element, value: $value");
        return null;
      }
    }

    return elements;
  }
}
