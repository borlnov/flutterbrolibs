// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This enum represents the different status of a manager.
enum ManagerStatus {
  /// The manager has been created.
  created,

  /// The manager has been initialized.
  initialized,

  /// The manager has been called after the first view has been built.
  afterBuilt,

  /// The manager has been disposed.
  disposed;
}
