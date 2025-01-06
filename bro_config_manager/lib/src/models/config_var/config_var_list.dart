// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/src/models/config_var/config_var.dart';
import 'package:bro_list_utility/bro_list_utility.dart';

/// This a converter for a single element of a json list.
// The value is null because the json array values are dynamic types.
// ignore: avoid_annotating_with_dynamic
typedef JsonListElementConverter<T> = T? Function(dynamic value);

/// {@macro abs_config_manager.ConfigVar.description}
///
/// If you want to use a list of [T] in your config file, you can use this class. If you want to use
/// a single value, use [ConfigVar] instead.
class ConfigVarList<T> extends ConfigVar<List<T>, List<dynamic>> {
  /// {@macro bro_config_manager.ConfigVar.constructor}
  ConfigVarList({
    required super.jsonPath,
    super.defaultValue,
    JsonListElementConverter<T>? elemConverter,
  }) : super(
          converter: (values) => _tryToCastFromDynamic(
            values: values,
            elemConverter: elemConverter,
          ),
        );

  /// {@macro bro_config_manager.ConfigVar.constructor.jsonPathList}
  ConfigVarList.jsonPathList({
    required super.jsonPathList,
    super.defaultValue,
    JsonListElementConverter<T>? elemConverter,
  }) : super.jsonPathList(
          converter: (values) => _tryToCastFromDynamic(
            values: values,
            elemConverter: elemConverter,
          ),
        );

  /// Try to cast a list of dynamic values to a list of [T].
  static List<T>? _tryToCastFromDynamic<T>({
    required List<dynamic> values,
    required JsonListElementConverter<T>? elemConverter,
  }) {
    if (elemConverter == null) {
      return ListUtility.tryToCastFromDynamic(values);
    }

    final tmpValues = <T>[];
    for (final value in values) {
      final convertedValue = elemConverter(value);
      if (convertedValue == null) {
        return null;
      }
      tmpValues.add(convertedValue);
    }

    return tmpValues;
  }
}
