// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:equatable/equatable.dart';

/// This class represents a log message.
class LogMessage extends Equatable {
  /// The message of the log.
  final dynamic message;

  /// The categories of the log.
  final List<String> categories;

  /// Create a [LogMessage].
  const LogMessage({
    required this.message,
    required this.categories,
  });

  /// The class properties
  @override
  List<Object?> get props => [message, categories];
}
