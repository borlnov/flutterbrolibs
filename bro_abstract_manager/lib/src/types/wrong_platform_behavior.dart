// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// The behavior to use when the platform is not supported by the manager.
enum WrongPlatformBehavior {
  /// Throw an error when the platform is not supported by the manager.
  throwError,

  /// Do not initialize the manager when the platform is not supported by the manager.
  doNotInitManager,

  /// Continue the process when the platform is not supported by the manager, as if it's supported.
  /// The manager will have to manage the case by itself.
  continueProcess;
}
