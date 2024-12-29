// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/models/env_map_file_element.dart';

/// This class is used to store a value from an environment variable.
///
/// It inherits from [EnvMapFileElement] to store the path to the value in the JSON file.
class EnvMapValueElement extends EnvMapFileElement {
  /// The value of the environment variable.
  final dynamic value;

  /// Class constructor.
  const EnvMapValueElement._({
    required super.jsonPath,
    required super.envKey,
    required super.valueType,
    required this.value,
  });

  /// Create a new [EnvMapValueElement] from the given [envMapElement] and [value].
  ///
  /// If not null, the [logger] will be used to log the errors.
  ///
  /// If the element can't be created, this will return null.
  static EnvMapValueElement? fromEnvMapElement({
    required EnvMapFileElement envMapElement,
    required String value,
    LoggerHelper? logger,
  }) {
    final parsedValue = envMapElement.valueType.parseValue(value);
    if (parsedValue == null) {
      logger?.warn("EnvMapValueElement: failed to parse the value: $value for the element: "
          "$envMapElement, it has not the right type: ${envMapElement.valueType}");
      return null;
    }

    return EnvMapValueElement._(
      jsonPath: envMapElement.jsonPath,
      envKey: envMapElement.envKey,
      valueType: envMapElement.valueType,
      value: parsedValue,
    );
  }

  /// List the properties of the class.
  @override
  List<Object?> get props => [
        ...super.props,
        value,
      ];
}
