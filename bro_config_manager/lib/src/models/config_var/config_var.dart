// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/errors/config_var_not_found_error.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';
import 'package:flutter/foundation.dart';

/// {@template abs_config_manager.ConfigVar.description}
/// This class is used to access a value in the configuration file.
///
/// The value can not exist in the configuration file.
///
/// The value is loaded only once and is stored in memory.
/// {@endtemplate}
///
/// If you want to get a list of values, use ConfigVarList instead
class ConfigVar<T> {
  /// The separator used to split the json path.
  static const String jsonPathSeparator = ".";

  /// The list of json path to access the value.
  ///
  /// {@template abs_config_manager.ConfigVar.jsonPath}
  /// The json path is used to access the value in the configuration file. Each element of the list
  /// is a key in the config json file.
  /// {@endtemplate}
  final List<String> _jsonPathList;

  /// The list of json path to access the value.
  /// {@macro abs_config_manager.ConfigVar.jsonPath}
  List<String> get jsonPathList => _jsonPathList;

  /// The flag to know if the value is loaded in the [ConfigVar] memory.
  bool _isLoaded;

  /// The loaded value.
  T? _loadedValue;

  /// {@template bro_config_manager.ConfigVar.constructor}
  /// Class constructor.
  ///
  /// {@macro abs_config_manager.ConfigVar.jsonPath}
  ///
  /// The elements in [jsonPath] have to be separated by the [jsonPathSeparator]. If you have `.`
  /// in a key, use [ConfigVar.jsonPathList] constructor instead.
  /// {@endtemplate}
  ConfigVar({
    required String jsonPath,
  })  : _jsonPathList = jsonPath.split(jsonPathSeparator),
        _isLoaded = false;

  /// {@template bro_config_manager.ConfigVar.constructor.jsonPathList}
  /// Class constructor.
  ///
  /// {@macro abs_config_manager.ConfigVar.jsonPath}
  /// {@endtemplate}
  ConfigVar.jsonPathList({
    required List<String> jsonPathList,
  })  : _jsonPathList = jsonPathList,
        _isLoaded = false;

  /// Load the value from the configuration file.
  ///
  /// If the value is already loaded, the function returns the value.
  ///
  /// If the value doesn't exist in the configuration file, the function will throw a
  /// [ConfigVarNotFoundError].
  ///
  /// If you want to override the behavior of this method, you can override [tryToLoadProcess].
  T load() {
    final value = tryToLoad();
    if (value == null) {
      throw ConfigVarNotFoundError(_jsonPathList);
    }

    return value;
  }

  /// Try to load the value from the configuration file.
  ///
  /// If the value is already loaded, the function returns the value.
  ///
  /// If the value doesn't exist in the configuration file, the function returns null.
  ///
  /// If you want to override the behavior of this method, you can override [tryToLoadProcess].
  T? tryToLoad() {
    if (!_isLoaded) {
      _loadedValue = tryToLoadProcess();
      _isLoaded = true;
    }

    return _loadedValue;
  }

  /// {@template bro_config_manager.ConfigVar.tryToLoadProcess}
  /// Try to load the value from the configuration file.
  ///
  /// If the value doesn't exist in the configuration file, the function returns null.
  /// {@endtemplate}
  @protected
  T? tryToLoadProcess() => ConfigCompanion.instance.tryToLoad(_jsonPathList);
}
