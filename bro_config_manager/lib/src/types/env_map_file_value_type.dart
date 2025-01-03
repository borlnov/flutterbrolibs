// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_types_utility/bro_types_utility.dart';
import 'package:bro_yaml_utility/bro_yaml_utility.dart';

/// This enum represents the different types of values that can be stored in a map file.
enum EnvMapFileValueType {
  /// This value type represents an integer.
  intEnv(["int", "integer"]),

  /// This value type represents a double.
  doubleEnv(["double", "float", "number"]),

  /// This value type represents a boolean.
  boolEnv(["bool", "boolean"]),

  /// This value type represents a string.
  stringEnv(["string"]),

  /// This value type represents a json object.
  objectEnv(["object", "yaml", "json", "map", "yml"]),

  /// This value type represents a json list.
  listEnv(["list", "array"]);

  /// This is the list of formats that can be used to represent the value type in a JSON file.
  final List<String> _jsonFormats;

  /// Enum constructor.
  const EnvMapFileValueType(this._jsonFormats);

  /// Try to parse a string to an [EnvMapFileValueType] value type.
  /// If the string is not a valid value type, return null.
  static EnvMapFileValueType? fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in EnvMapFileValueType.values) {
      if (type._jsonFormats.contains(lowerValue)) {
        return type;
      }
    }

    return null;
  }

  /// Try to parse a string to this value type.
  dynamic parseValue(
    String value, {
    LoggerHelper? logger,
  }) =>
      switch (this) {
        EnvMapFileValueType.intEnv => int.tryParse(value),
        EnvMapFileValueType.doubleEnv => double.tryParse(value),
        EnvMapFileValueType.boolEnv => BoolUtility.tryParse(value),
        EnvMapFileValueType.stringEnv => value,
        EnvMapFileValueType.objectEnv => YamlUtility.loadYamlDocToJsonObj(
            content: value,
            logger: logger,
          ),
        EnvMapFileValueType.listEnv => YamlUtility.loadYamlDocToJsonArray(
            content: value,
            logger: logger,
          ),
      };
}
