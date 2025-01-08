// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// Thrown when the platform can't be guessed.
class CantGuessPlatformError extends Error {
  /// Get the string representation of the error.
  @override
  String toString() => "Can't guess the current platform.";
}
