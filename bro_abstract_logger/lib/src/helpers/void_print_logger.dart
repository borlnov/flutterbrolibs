// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_logger/src/types/logs_level.dart';

/// This class is a logger that does nothing. This is useful when you want to disable the logs but
/// keep the same interface.
class VoidPrintLogger with MixinExternalLogger {
  /// The singleton instance of the [VoidPrintLogger].
  static VoidPrintLogger? _instance;

  /// Get the singleton instance of the [VoidPrintLogger].
  static VoidPrintLogger get instance {
    _instance ??= VoidPrintLogger._();
    return _instance!;
  }

  /// Private constructor.
  VoidPrintLogger._();

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
  @override
  void log(LogsLevel level, String message, {List<String> categories = const []}) {
    // Nothing to do
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  @override
  void logErrorWithException(
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) {
    // Nothing to do
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {}
}
