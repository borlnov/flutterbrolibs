// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This error is thrown when the config file is not found or not valid.
class ConfigFileError extends Error {
  /// Return a string representation of the error.
  @override
  String toString() => "Init config manager failed";
}
