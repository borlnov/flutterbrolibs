// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/types/logs_level.dart';

/// This mixin provides a way to log messages with different levels.
mixin MixinExternalLogger {
  /// This method logs a [message] with the [LogsLevel.trace] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void trace(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.trace,
        message,
        categories: categories,
      );

  /// This method logs a [message] with the [LogsLevel.debug] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void debug(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.debug,
        message,
        categories: categories,
      );

  /// This method logs a [message] with the [LogsLevel.info] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void info(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.info,
        message,
        categories: categories,
      );

  /// This method logs a [message] with the [LogsLevel.warn] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void warn(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.warn,
        message,
        categories: categories,
      );

  /// This method logs a [message] with the [LogsLevel.error] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void error(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.error,
        message,
        categories: categories,
      );

  /// This method logs a [message] with the [LogsLevel.fatal] level.
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  void fatal(
    String message, {
    List<String> categories = const [],
  }) =>
      log(
        LogsLevel.fatal,
        message,
        categories: categories,
      );

  /// {@template bro_abstract_logger.MixinExternalLogger.log}
  /// This method logs a [message] with the provided [level].
  ///
  /// {@template bro_abstract_logger.MixinExternalLogger.categories}
  /// The [categories] parameter is used to add categories to the log message. It can be used to
  /// filter logs by categories or to add more context to the logs. The first category is the main
  /// category of the logger and the last one is the most specific.
  /// {@endtemplate}
  /// {@endtemplate}
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  });

  /// {@template bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  /// This method logs an [exception].
  ///
  /// If [isFatal] is true, the level will be [LogsLevel.fatal].
  /// If [isFatal] is false, the level will be [LogsLevel.error].
  ///
  /// {@macro bro_abstract_logger.MixinExternalLogger.categories}
  /// {@endtemplate}
  void logErrorWithException(
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  });

  /// {@template bro_abstract_logger.MixinExternalLogger.dispose}
  /// This method disposes the logger.
  /// {@endtemplate}
  Future<void> dispose();
}
