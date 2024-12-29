// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_yaml_utility/bro_yaml_utility.dart';

/// Utility class to parse a YAML file content
abstract final class GlobalParseFileUtility {
  /// Parse a YAML config file content.
  ///
  /// [configFolderPath] is the path to the folder containing the config file.
  ///
  /// [fileName] is the name of the file to parse (it contains the file extension).
  ///
  /// If not null, the [logger] will be used to log the errors.
  static ({bool success, Map<String, dynamic>? value}) parseConfigFile({
    required String configFolderPath,
    required String fileName,
    LoggerHelper? logger,
  }) {
    final result = _readFileContent(
      configFolderPath: configFolderPath,
      fileName: fileName,
      logger: logger,
    );

    if (!result.success) {
      return (success: false, value: null);
    }

    if (result.content == null) {
      // The file may not exist
      return (success: true, value: null);
    }

    final json = YamlUtility.loadYamlDocToJson<Map<String, dynamic>>(
      content: result.content!,
      logger: logger,
    );

    if (json == null) {
      logger?.warn("Failed to parse the json content of the file: $fileName");
      return (success: false, value: null);
    }

    return (success: true, value: json);
  }

  /// Read the content of a file.
  ///
  /// [configFolderPath] is the path to the folder containing the config file.
  ///
  /// [fileName] is the name of the file to parse (it contains the file extension).
  ///
  /// If not null, the [logger] will be used to log the errors.
  static ({bool success, String? content}) _readFileContent({
    required String configFolderPath,
    required String fileName,
    required LoggerHelper? logger,
  }) {
    for (final extension in config_files_constants.configYamlExtensions) {
      final file = File('$configFolderPath/$fileName$extension');
      if (!file.existsSync()) {
        continue;
      }

      String? content;
      try {
        content = file.readAsStringSync();
      } catch (e) {
        logger?.error("Failed to read the content of the file: $fileName$extension, error: $e");
      }

      return (success: (content != null), content: content);
    }

    return (success: true, content: null);
  }
}
