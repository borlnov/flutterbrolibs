// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This is the status of the global manager.
enum GlobalManagerStatus {
  /// The global manager is created.
  created,

  /// The global manager and its managers are initialized. The initialization after the first view
  /// has begun.
  initializingAfterFirstViewBuilt,

  /// The global manager and its managers are completly ready, the initialization after the first
  /// view built is done.
  ready,

  /// The global manager has started the disposing.
  disposing;
}
