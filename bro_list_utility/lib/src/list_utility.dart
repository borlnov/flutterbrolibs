// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// This class provides utility methods to manipulate lists.
abstract final class ListUtility {
  /// This method tries to cast a list of dynamic values to a list of type [T].
  ///
  /// If the cast is not possible, the method will return null.
  ///
  /// Contrary to the `cast` method (that lazily tests if the cast is possible), this method will
  /// return null if the cast is not possible.
  ///
  /// If [logger] is not null, the method will log the errors.
  static List<T>? tryToCastFromDynamic<T>(
    List<dynamic> values, {
    LoggerHelper? logger,
    bool displayLog = true,
  }) {
    final tmpValues = <T>[];
    for (final value in values) {
      if (value is! T) {
        if (displayLog && logger != null) {
          logger.warn("The given list: $values, contains elements which are not of "
              "${T.runtimeType} type");
        }
        return null;
      }
      tmpValues.add(value);
    }

    return tmpValues;
  }
}
