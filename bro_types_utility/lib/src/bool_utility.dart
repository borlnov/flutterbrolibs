// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_types_utility/src/errors/boolean_parse_exception.dart';

/// Utility class for boolean.
abstract final class BoolUtility {
  /// List of string that represent a true value.
  static const List<String> trueValues = ['true', '1', 'yes', 'on'];

  /// List of string that represent a false value.
  static const List<String> falseValues = ['false', '0', 'no', 'off'];

  /// Try to parse a string to a boolean.
  ///
  /// Return null if the value is not a boolean.
  static bool? tryParse(String value) {
    if (trueValues.contains(value)) {
      return true;
    }

    if (falseValues.contains(value)) {
      return false;
    }

    return null;
  }

  /// Parse a string to a boolean.
  ///
  /// If the value is not a boolean, it will throw an exception.
  static bool parse(String value) {
    final parsedValue = tryParse(value);
    if (parsedValue == null) {
      throw BooleanParseError(value);
    }

    return parsedValue;
  }
}
