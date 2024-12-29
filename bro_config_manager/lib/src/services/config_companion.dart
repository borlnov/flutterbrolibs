// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_list_utility/bro_list_utility.dart';

/// This class is a companion to load config from a json file.
///
/// This is a singleton class, and you need to create it before using it. The class is a singleton
/// because we want to access the [_json] from the ConfigVar classes without using the global
/// manager.
class ConfigCompanion {
  /// The singleton instance of the class.
  static ConfigCompanion? _instance;

  /// The getter of the singleton instance.
  static ConfigCompanion get instance => _instance!;

  /// Create the singleton instance of the class, from the [json] and the [loggerHelper].
  static void create({
    required Map<String, dynamic> json,
    required LoggerHelper loggerHelper,
  }) {
    if (_instance != null) {
      // Nothing to do
      return;
    }

    _instance = ConfigCompanion(
      json: json,
      loggerHelper: loggerHelper,
    );
  }

  /// This is the config [_json]
  final Map<String, dynamic> _json;

  /// The logger helper to use for the companion.
  final LoggerHelper loggerHelper;

  /// Create a new instance of the class.
  const ConfigCompanion({
    required Map<String, dynamic> json,
    required this.loggerHelper,
  }) : _json = json;

  /// Try to load a value of type [T] from the json file. If you want to load a list of values, use
  /// [tryToLoadList] instead.
  ///
  /// [jsonPath] is the list of keys to access the value in the json file.
  T? tryToLoad<T>(List<String> jsonPath) {
    final value = _getJsonValue(jsonPath);
    if (value == null) {
      return null;
    }

    if (value is! T) {
      loggerHelper.warn("The json value: $value, isn't a ${T.runtimeType}, we can't load "
          "config from it");
      return null;
    }

    return value;
  }

  /// Try to load a list of values of type [T] from the json file. If you want to load a simple
  /// value, use [tryToLoad] instead.
  ///
  /// [jsonPath] is the list of keys to access the value in the json file.
  List<T>? tryToLoadList<T>(List<String> jsonPath) {
    final values = _getJsonValue(jsonPath);
    if (values == null) {
      return null;
    }

    if (values is! List<dynamic>) {
      loggerHelper.warn("The json value: $values, isn't a list, we can't load config from it");
      return null;
    }

    return ListUtility.tryToCastFromDynamic(values);
  }

  /// Get the value from the [_json] object with the given [jsonPath].
  dynamic _getJsonValue(List<String> jsonPath) {
    var tmpJson = _json;
    dynamic tmpValue;

    for (var idx = 0; idx < jsonPath.length; ++idx) {
      tmpValue = tmpJson[jsonPath[idx]];
      if (tmpValue == null) {
        break;
      }

      if (idx == (jsonPath.length - 1)) {
        // Nothing more to do here
      } else if (tmpValue is! Map<String, dynamic>) {
        // We can't go further; therefore the value is not accessible
        tmpValue = null;
        break;
      } else {
        tmpJson = tmpValue;
      }
    }

    return tmpValue;
  }
}
