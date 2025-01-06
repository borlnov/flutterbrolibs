// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/config_var/config_var.dart';

/// {@macro abs_config_manager.ConfigVar.description}
///
/// A simple config var that does not need a transformer
class SimpleConfigVar<T> extends ConfigVar<T, T> {
  /// {@macro bro_config_manager.ConfigVar.constructor}
  SimpleConfigVar({
    required super.jsonPath,
    super.defaultValue,
  });

  /// {@macro bro_config_manager.ConfigVar.constructor.jsonPathList}
  SimpleConfigVar.jsonPathList({
    required super.jsonPathList,
    super.defaultValue,
  }) : super.jsonPathList();
}
