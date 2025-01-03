// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// Error thrown when a dead loop is detected while registering managers.
class ManagerRegisteringDeadLoopError extends Error {
  /// Returns a string representation of this error.
  @override
  String toString() => 'Dead loop detected while registering managers';
}
