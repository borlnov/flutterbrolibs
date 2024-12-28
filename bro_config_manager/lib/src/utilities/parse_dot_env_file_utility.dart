import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ParseDotEnvFileUtility {
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
      fileBaseName: environmentType.fileName,
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

  static Future<Map<String, String>?> _parseFromDotEnvFile({
    required String configFolderPath,
    required String fileBaseName,
    required LoggerHelper? logger,
  }) async {
    final env = DotEnv();
    Map<String, String>? envMap;
    try {
      await env.load(
        fileName: "$configFolderPath/$fileBaseName${config_files_constants.dotEnvFileSuffix}",
        isOptional: true,
      );
      envMap = env.env;
    } catch (e) {
      logger?.error("Failed to load the .env file: $fileBaseName, error: $e");
    }

    return envMap;
  }
}
