// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// This utility provides a way to parse the .env files.
abstract final class ParseDotEnvFileUtility {
  /// Parse all the .env files and merge them together.
  ///
  /// [configFolderPath] is the path to the folder containing the .env files.
  ///
  /// [environmentType] is the current app type environment.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the merged .env values or null if an error occurred.
  ///
  /// The .env files are parsed in the following order:
  /// - .env
  /// - default.env
  /// - [environmentType].env
  /// - local.env
  static Future<Map<String, String>?> parseDotEnvFiles({
    required String configFolderPath,
    required ConfigEnvironmentType environmentType,
    LoggerHelper? logger,
  }) async {
    final classicalEnv = await _parseFromDotEnvFile(
      configFolderPath: configFolderPath,
      fileBaseName: "",
      logger: logger,
    );

    if (classicalEnv == null) {
      return null;
    }

    final defaultEnv = await _parseFromDotEnvFile(
      configFolderPath: configFolderPath,
      fileBaseName: config_files_constants.defaultConfigFileName,
      logger: logger,
    );

    if (defaultEnv == null) {
      return null;
    }

    final envEnv = await _parseFromDotEnvFile(
      configFolderPath: configFolderPath,
      fileBaseName: environmentType.fileBaseName,
      logger: logger,
    );

    if (envEnv == null) {
      return null;
    }

    final localEnv = await _parseFromDotEnvFile(
      configFolderPath: configFolderPath,
      fileBaseName: config_files_constants.localConfigFileName,
      logger: logger,
    );

    if (localEnv == null) {
      return null;
    }

    final tmpEnv = Map<String, String>.from(classicalEnv);
    tmpEnv.addAll(defaultEnv);
    tmpEnv.addAll(envEnv);
    tmpEnv.addAll(localEnv);

    return tmpEnv;
  }

  /// Parse the .env file with the given [fileBaseName].
  ///
  /// [configFolderPath] is the path to the folder containing the .env files.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// Returns the parsed .env values or null if an error occurred.
  static Future<Map<String, String>?> _parseFromDotEnvFile({
    required String configFolderPath,
    required String fileBaseName,
    required LoggerHelper? logger,
  }) async {
    final env = DotEnv();
    Map<String, String>? envMap;
    try {
      await env.load(
        fileName: "$configFolderPath/$fileBaseName${config_files_constants.dotEnvFileExtension}",
        isOptional: true,
      );
      envMap = env.env;
    } catch (e) {
      logger?.error("Failed to load the .env file: $fileBaseName, error: $e");
    }

    return envMap;
  }
}
