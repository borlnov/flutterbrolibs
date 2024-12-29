// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This error is thrown when a required config var is not found in the config files.
class ConfigVarNotFoundError extends Error {
  /// The json path of the config var that have not been found.
  final List<String> jsonPath;

  /// Create a new [ConfigVarNotFoundError] with the given [jsonPath].
  ConfigVarNotFoundError(this.jsonPath);

  /// Return a string representation of the error.
  @override
  String toString() => "The config var: $jsonPath have not been found in the config files, but we "
      "load it as it is.";
}
