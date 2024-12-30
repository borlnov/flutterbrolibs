// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// An exception that is thrown when a boolean value cannot be parsed.
class BooleanParseError extends Error {
  /// The value that could not be parsed.
  final String value;

  /// Create a new [BooleanParseError] with the given [value].
  BooleanParseError(this.value);

  /// Returns a string representation of this object.
  @override
  String toString() => 'Failed to parse the boolean value: $value';
}
