// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_file_utility/bro_file_utility.dart';
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
  static Future<({bool success, Map<String, dynamic>? value})> parseConfigFile({
    required String configFolderPath,
    required String fileName,
    LoggerHelper? logger,
  }) async {
    final result = await _readAssetFileContent(
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

    final json = YamlUtility.loadYamlDocToJsonObj(
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
  static Future<({bool success, String? content})> _readAssetFileContent({
    required String configFolderPath,
    required String fileName,
    required LoggerHelper? logger,
  }) async {
    for (final extension in config_files_constants.configYamlExtensions) {
      final content = await AssetsUtility.loadAssetString(
        assetPath: '$configFolderPath/$fileName$extension',
        logger: logger,
      );

      if (content == null) {
        // The file may not exist, we continue to the next extension
        continue;
      }

      return (success: true, content: content);
    }

    return (success: true, content: null);
  }
}
