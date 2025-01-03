// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

import '../models/test_log_model.dart';

/// This is a print logger which keeps the log info in a [logs] list.
class TestPrintLogger with MixinExternalLogger {
  /// The list of all the logs.
  final List<TestLogModel> logs = [];

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
  @override
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  }) {
    if (level == LogsLevel.none) {
      // Do nothing
      return;
    }

    logs.add(TestLogModel(
      message: message,
      level: level,
      categories: categories,
    ));
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  @override
  void logErrorWithException(
    // We use dynamic to be able to pass any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) {
    logs.add(TestLogModel(
      message: "$exception, stackTrace: $stackTrace",
      level: isFatal ? LogsLevel.fatal : LogsLevel.error,
      categories: categories,
    ));
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {}
}
