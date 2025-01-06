// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// Error thrown when the global manager was not created and we try to access it.
class GlobalManagerNotCreatedError extends Error {
  /// Returns a string representation of this error.
  @override
  String toString() => "The global manager was not created.";
}
