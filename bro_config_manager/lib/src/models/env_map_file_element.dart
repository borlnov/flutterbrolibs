// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/types/env_map_file_value_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// The class that represents an element in the environment map file.
///
/// The element can be a simple string or a complex object.
class EnvMapFileElement extends Equatable {
  /// The key to get the name of the complex object.
  static const attrNameKey = "__name";

  /// The key to get the format of the complex object.
  static const attrFormatKey = "__format";

  /// The path to the element in the JSON file.
  final List<String> jsonPath;

  /// The key to get the value from the environment.
  final String envKey;

  /// The type of the value.
  final EnvMapFileValueType valueType;

  /// Create a new [EnvMapFileElement] with the given [jsonPath], [envKey] and [valueType].
  @protected
  const EnvMapFileElement({
    required this.jsonPath,
    required this.envKey,
    required this.valueType,
  });

  /// Create a new [EnvMapFileElement] from the given [envKey] and [currentJsonPath]. This creates a
  /// simple element with a string value type.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// If the element can't be created, this will return null.
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

  /// Create a new [EnvMapFileElement] from the given [json] and [currentJsonPath]. This creates a
  /// complex element. The [json] has to contain the [attrNameKey] and [attrFormatKey] keys.
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// If the element can't be created, this will return null.
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

  /// List the properties of the model.
  @override
  @mustCallSuper
  List<Object?> get props => [jsonPath, envKey, valueType];
}
