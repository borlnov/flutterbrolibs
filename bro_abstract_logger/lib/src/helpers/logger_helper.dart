// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/sub_logger_helper.dart';
import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_logger/src/types/logs_level.dart';
import 'package:flutter/foundation.dart';

/// This class is a helper to log messages with a specific category and minLevel.
///
/// The external [_logger] is used to log the messages and can be updated with [updateLogger].
class LoggerHelper {
  /// This is the list of categories for this logger.
  ///
  /// It can be used to filter logs by categories or to add more context to the logs.
  ///
  /// The first category is the main category of the logger and the last one is the most specific.
  final List<String> categories;

  /// This is the minimum level to log messages.
  ///
  /// If the level of the message is lower than this level, the message will be skipped. If null,
  /// all messages will be logged (the _logger will decide if it logs the message or not).
  final LogsLevel? minLevel;

  /// This is the external logger used to log messages.
  MixinExternalLogger? _logger;

  /// This is the getter for the external logger.
  ///
  /// [_logger] is nullable but if [LoggerHelper] is created with the default constructor, it won't
  /// be null.
  /// If [LoggerHelper] is created with the [createSubLogger] method, [_logger] will be null, but
  /// this getter will return the parent logger in the [SubLoggerHelper] class.
  @protected
  MixinExternalLogger get logger => _logger!;

  /// This is the default constructor.
  ///
  /// If you want to create a sub-logger, you should use the [createSubLogger] method.
  LoggerHelper({
    required MixinExternalLogger logger,
    String? category,
    this.minLevel,
  })  : categories = [
          if (category != null) category,
        ],
        _logger = logger;

  /// This is the constructor for the sub-logger.
  ///
  /// [categories] has to contain the parent categories.
  @protected
  LoggerHelper.subLogger({
    required this.categories,
    this.minLevel,
  }) : _logger = null;

  /// This method creates a sub-logger.
  ///
  /// It adds the [category] to the categories of the parent logger. If [minLevel] is not provided,
  /// the minLevel of the parent logger will be used.
  LoggerHelper createSubLogger({
    String? category,
    LogsLevel? minLevel,
  }) =>
      SubLoggerHelper(
        category: category,
        parent: this,
        minLevel: minLevel ?? this.minLevel,
      );

  /// {@template bro_abstract_logger.LoggerHelper.updateLogger}
  /// This method updates the external logger.
  /// {@endtemplate}
  // We don't use a setter here because we want to be able to override the method in the sub-logger.
  // ignore: use_setters_to_change_properties
  void updateLogger(MixinExternalLogger logger) {
    _logger = logger;
  }

  /// This method logs a [message] with the trace level.
  void trace(String message) => log(
        LogsLevel.trace,
        message,
      );

  /// This method logs a [message] with the debug level.
  void debug(String message) => log(
        LogsLevel.debug,
        message,
      );

  /// This method logs a [message] with the info level.
  void info(String message) => log(
        LogsLevel.info,
        message,
      );

  /// This method logs a [message] with the warn level.
  void warn(String message) => log(
        LogsLevel.warn,
        message,
      );

  /// This method logs a [message] with the error level.
  void error(String message) => log(
        LogsLevel.error,
        message,
      );

  /// This method logs a [message] with the fatal level.
  void fatal(String message) => log(
        LogsLevel.fatal,
        message,
      );

  /// {@template bro_abstract_logger.LoggerHelper.log}
  /// This method logs a [message] with the provided [level].
  /// {@endtemplate}
  void log(LogsLevel level, String message) {
    if (!_testIfLoggable(level)) {
      // We skip log because the level is lower than the minLevel
      return;
    }

    logger.log(
      level,
      message,
      categories: categories,
    );
  }

  /// {@template bro_abstract_logger.LoggerHelper.logErrorWithException}
  /// This method logs an [exception].
  ///
  /// If [isFatal] is true, the level will be [LogsLevel.fatal].
  /// If [isFatal] is false, the level will be [LogsLevel.error].
  /// {@endtemplate}
  void logErrorWithException(
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    bool isFatal = false,
    StackTrace? stackTrace,
  }) {
    if (!_testIfLoggable(isFatal ? LogsLevel.fatal : LogsLevel.error)) {
      // We skip log because the error level is lower than the minLevel
      return;
    }

    logger.logErrorWithException(
      exception,
      isFatal: isFatal,
      stackTrace: stackTrace,
      categories: categories,
    );
  }

  /// This method tests if the message is loggable with the provided [level].
  bool _testIfLoggable(LogsLevel level) => minLevel == null || level.index >= minLevel!.index;
}
