import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/types/env_map_file_value_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EnvMapFileElement extends Equatable {
  static const attrNameKey = "__name";
  static const attrFormatKey = "__format";

  final List<String> jsonPath;
  final String envKey;
  final EnvMapFileValueType valueType;

  @protected
  const EnvMapFileElement({
    required this.jsonPath,
    required this.envKey,
    required this.valueType,
  });

  static EnvMapFileElement? fromStringType({
    required String envKey,
    required List<String> currentJsonPath,
    LoggerHelper? logger,
  }) {
    if (currentJsonPath.isEmpty) {
      logger?.warn("EnvMapFileElement: failed to parse the element with env key: $envKey, the "
          "currentJsonPath is empty");
      return null;
    }

    return EnvMapFileElement(
      jsonPath: currentJsonPath,
      envKey: envKey,
      valueType: EnvMapFileValueType.stringEnv,
    );
  }

  static EnvMapFileElement? fromComplexType({
    required Map<String, dynamic> json,
    required List<String> currentJsonPath,
    LoggerHelper? logger,
  }) {
    if (currentJsonPath.isEmpty) {
      logger?.warn("EnvMapFileElement: failed to parse the element: $json, the currentJsonPath is "
          "empty");
      return null;
    }

    final name = json[attrNameKey];
    if (name == null || name is! String) {
      logger?.warn("EnvMapFileElement: failed to parse the element: $json, it's not a valid "
          "element with the attribute: $attrNameKey");
      return null;
    }

    final format = json[attrFormatKey];
    if (format == null || format is! String) {
      logger?.warn("EnvMapFileElement: failed to parse the element: $json, it's not a valid "
          "element with the attribute: $attrFormatKey");
      return null;
    }

    final valueType = EnvMapFileValueType.fromString(format);
    if (valueType == null) {
      logger?.warn("EnvMapFileElement: failed to parse the element: $json, the format is not "
          "supported");
      return null;
    }

    return EnvMapFileElement(
      jsonPath: currentJsonPath,
      envKey: name,
      valueType: valueType,
    );
  }

  @override
  @mustCallSuper
  List<Object?> get props => [jsonPath, envKey, valueType];
}
