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
/// If you want to get a list of values, use ConfigVarList instead.
///
/// [Y] type represents the type of the JSON value in the configuration file. [T] type represents
/// the type of the value to use in the code. If [Y] and [T] are the same, you can use the
/// SimpleConfigVar class instead.
class ConfigVar<T, Y> {
  /// The separator used to split the json path.
  static const String jsonPathSeparator = ".";

  /// The default value to use if the value is not found in the configuration file.
  final T? defaultValue;

  /// The list of json path to access the value.
  ///
  /// {@template abs_config_manager.ConfigVar.jsonPath}
  /// The json path is used to access the value in the configuration file. Each element of the list
  /// is a key in the config json file.
  /// {@endtemplate}
  final List<String> _jsonPathList;

  /// This is a method to convert the value [Y] from the configuration file to the type [T].
  final T? Function(Y value)? _converter;

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
    this.defaultValue,
    T? Function(Y value)? converter,
  })  : _jsonPathList = jsonPath.split(jsonPathSeparator),
        _isLoaded = false,
        _converter = converter;

  /// {@template bro_config_manager.ConfigVar.constructor.jsonPathList}
  /// Class constructor.
  ///
  /// {@macro abs_config_manager.ConfigVar.jsonPath}
  /// {@endtemplate}
  ConfigVar.jsonPathList({
    required List<String> jsonPathList,
    this.defaultValue,
    T? Function(Y value)? converter,
  })  : _jsonPathList = jsonPathList,
        _isLoaded = false,
        _converter = converter;

  /// Load the value from the configuration file.
  ///
  /// {@macro bro_config_manager.ConfigVar.tryToLoad.parameters}
  ///
  /// If the value doesn't exist in the configuration file, the function will throw a
  /// [ConfigVarNotFoundError].
  ///
  /// If you want to override the behavior of this method, you can override [tryToLoadProcess].
  T load({
    bool useCache = true,
    bool useDefaultValue = true,
  }) {
    final value = tryToLoad(
      useCache: useCache,
      useDefaultValue: useDefaultValue,
    );
    if (value == null) {
      throw ConfigVarNotFoundError(_jsonPathList);
    }

    return value;
  }

  /// Try to load the value from the configuration file.
  ///
  /// {@template bro_config_manager.ConfigVar.tryToLoad.parameters}
  /// - [useCache]: If true, the function will use the value stored in memory. If false, the
  ///   function will try to load the value from the configuration file.
  /// - [useDefaultValue]: If true, the function will use the [defaultValue] if the value is not
  ///   found in the configuration file.
  /// {@endtemplate}
  ///
  /// If the value doesn't exist in the configuration file and if the [defaultValue] is null, the
  /// function returns null.
  ///
  /// If you want to override the behavior of this method, you can override [tryToLoadProcess].
  T? tryToLoad({
    bool useCache = true,
    bool useDefaultValue = false,
  }) {
    if (!useCache || !_isLoaded) {
      _loadedValue = tryToLoadProcess();
      if (useDefaultValue && _loadedValue == null) {
        _loadedValue = defaultValue;
      }
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
  T? tryToLoadProcess() {
    if (_converter == null) {
      return ConfigCompanion.instance.tryToLoad<T>(_jsonPathList);
    }

    final configValue = ConfigCompanion.instance.tryToLoad<Y>(_jsonPathList);
    if (configValue == null) {
      return null;
    }

    return _converter(configValue);
  }
}
