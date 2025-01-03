// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/config_var/config_var.dart';
import 'package:flutter/foundation.dart';

/// {@macro abs_config_manager.ConfigVar.description}
///
/// A [ConfigVar] with a default value.
class ConfigVarWithDefault<T> extends ConfigVar<T> {
  /// The default value to use if the value is not found in the configuration file.
  final T defaultValue;

  /// {@macro bro_config_manager.ConfigVar.constructor}
  ConfigVarWithDefault({
    required super.jsonPath,
    required this.defaultValue,
  });

  /// {@macro bro_config_manager.ConfigVar.constructor.jsonPathList}
  ConfigVarWithDefault.jsonPathList({
    required super.jsonPathList,
    required this.defaultValue,
  }) : super.jsonPathList();

  /// Load the value from the configuration file.
  ///
  /// If the value is already loaded, the function returns the value.
  ///
  /// If the value doesn't exist in the configuration file, the function will use the
  /// [defaultValue].
  @override
  T load() => tryToLoad() ?? defaultValue;

  /// Try to load the value from the configuration file.
  ///
  /// We override the [tryToLoad] method to make it protected and not callable from other classes.
  @protected
  @override
  T? tryToLoad() => super.tryToLoad();
}
