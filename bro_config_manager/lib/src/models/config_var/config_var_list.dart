// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/config_var/config_var.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';

/// {@macro abs_config_manager.ConfigVar.description}
///
/// If you want to use a list of [T] in your config file, you can use this class. If you want to use
/// a single value, use [ConfigVar] instead.
class ConfigVarList<T> extends ConfigVar<List<T>> {
  /// {@macro bro_config_manager.ConfigVar.constructor}
  ConfigVarList({
    required super.jsonPath,
  });

  /// {@macro bro_config_manager.ConfigVar.constructor.jsonPathList}
  ConfigVarList.jsonPathList({
    required super.jsonPathList,
  }) : super.jsonPathList();

  /// {@macro bro_config_manager.ConfigVar.tryToLoadProcess}
  @override
  List<T>? tryToLoadProcess() => ConfigCompanion.instance.tryToLoadList<T>(jsonPathList);
}
