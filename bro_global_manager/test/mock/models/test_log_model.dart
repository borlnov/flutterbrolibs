// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/types/logs_level.dart';
import 'package:equatable/equatable.dart';

/// A model to test the logging system.
class TestLogModel extends Equatable {
  /// The message to log.
  final String message;

  /// The level of the log.
  final LogsLevel level;

  /// The categories of the log.
  final List<String> categories;

  /// Create a [TestLogModel] with the [message], [level], and [categories].
  const TestLogModel({
    required this.message,
    required this.level,
    this.categories = const [],
  });

  /// Return the string representation of the [TestLogModel].
  @override
  String toString() => 'TestLogModel{message: $message, level: $level, categories: $categories}';

  /// Return the properties of the [TestLogModel].
  @override
  List<Object?> get props => [message, level, ...categories];
}
