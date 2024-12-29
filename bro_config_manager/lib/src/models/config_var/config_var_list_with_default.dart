// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/config_var/config_var_with_default.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';

/// {@macro abs_config_manager.ConfigVar.description}
///
/// This allows to use a list of [T] in your config file with a default value.
class ConfigVarListWithDefault<T> extends ConfigVarWithDefault<List<T>> {
  /// {@macro bro_config_manager.ConfigVar.constructor}
  ConfigVarListWithDefault({
    required super.jsonPath,
    required super.defaultValue,
  });

  /// {@macro bro_config_manager.ConfigVar.constructor.jsonPathList}
  ConfigVarListWithDefault.jsonPathList({
    required super.jsonPathList,
    required super.defaultValue,
  }) : super.jsonPathList();

  /// {@macro bro_config_manager.ConfigVar.tryToLoadProcess}
  @override
  List<T>? tryToLoadProcess() => ConfigCompanion.instance.tryToLoadList<T>(jsonPathList);
}
