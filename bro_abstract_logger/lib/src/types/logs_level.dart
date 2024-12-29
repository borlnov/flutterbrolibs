// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This enum is used to define the level of logs in the package.
enum LogsLevel {
  /// The trace level is used to log the most detailed information.
  trace,

  /// The debug level is used to log debug information.
  debug,

  /// The info level is used to log information.
  info,

  /// The warn level is used to log warnings.
  warn,

  /// The error level is used to log errors.
  error,

  /// The fatal level is used to log fatal errors.
  ///
  /// This level is used to log errors that will cause the application to crash.
  fatal,

  /// The none level is used to disable all logs.
  none;
}
