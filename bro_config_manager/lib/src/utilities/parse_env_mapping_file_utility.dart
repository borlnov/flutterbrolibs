import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/data/config_files_constants.dart' as config_files_constants;
import 'package:bro_config_manager/src/models/env_map_file_element.dart';
import 'package:bro_config_manager/src/models/env_map_value_element.dart';
import 'package:bro_config_manager/src/utilities/global_parse_file_utility.dart';

abstract final class ParseEnvMappingFileUtility {
  static Map<String, dynamic>? transformEnvMapValuesToJson({
    required List<EnvMapValueElement> envValues,
    LoggerHelper? logger,
  }) {
    final json = <String, dynamic>{};
    var tmpJson = json;
    for (final envValue in envValues) {
      final jsonPath = envValue.jsonPath;
      for (var idx = 0; idx < jsonPath.length; ++idx) {
        final key = jsonPath[idx];
        if (idx == jsonPath.length - 1) {
          tmpJson[key] = envValue.value;
        } else {
          final tmpValue = tmpJson[key] ?? <String, dynamic>{};

          if (tmpValue is! Map<String, dynamic>) {
            logger?.warn("Env map parsing: failed to parse the element: $envValue, the json path "
                "is not valid, the key: $key is used for a value and a map");
            return null;
          }

          tmpJson = tmpValue;
        }
      }

      tmpJson = json;
    }

    return json;
  }

  static List<EnvMapFileElement>? parseMappingFile({
    required String configFolderPath,
    LoggerHelper? logger,
  }) {
    final envMapFile = GlobalParseFileUtility.parseConfigFile(
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
          currentJsonPath: currentJsonPath,
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
