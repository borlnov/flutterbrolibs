// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// This class is used as external logger to send logs to Firebase Crashlytics.
class CrashlyticsLogger with MixinExternalLogger {
  /// True if Crashlytics is enabled and the logs should be sent to Firebase Crashlytics.
  final bool crashlyticsEnabled;

  /// The number of last logs to send to Firebase Crashlytics.
  /// If null or if the number is less than or equal to 0, no logs will be sent to Firebase
  /// Crashlytics.
  ///
  /// This works as a circular buffer. The first logs are removed when the buffer is full.
  final int? includeLastLogsNb;

  /// The minimum level of logs to send to Firebase Crashlytics.
  final LogsLevel includeLastLogsMinLevel;

  /// The last logs to send to Firebase Crashlytics.
  final List<String> _lastLogs;

  /// Class constructor
  CrashlyticsLogger({
    required this.crashlyticsEnabled,
    required this.includeLastLogsNb,
    required this.includeLastLogsMinLevel,
  }) : _lastLogs = [];

  /// {@macro bro_abstract_logger.MixinExternalLogger.log}
  /// If the log is an error or fatal, we send it to Firebase Crashlytics. Otherwise, we add it to
  /// the last logs
  @override
  void log(
    LogsLevel level,
    String message, {
    List<String> categories = const [],
  }) {
    if (!crashlyticsEnabled) {
      return;
    }

    if (_isAnError(level)) {
      // We fire the error
      unawaited(_fireError(
        exception: message,
        level: level,
        categories: categories,
      ));
      return;
    }

    _addLastLogsIfNeeded(
      level: level,
      message: message,
      categories: categories,
    );
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.logErrorWithException}
  ///
  /// We send the log to Firebase Crashlytics.
  @override
  void logErrorWithException(
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception, {
    StackTrace? stackTrace,
    bool isFatal = false,
    List<String> categories = const [],
  }) {
    if (!crashlyticsEnabled) {
      return;
    }

    unawaited(_fireError(
      exception: exception,
      level: isFatal ? LogsLevel.fatal : LogsLevel.error,
      stackTrace: stackTrace,
      categories: categories,
    ));
  }

  /// Test if the [level] is an error or fatal log, that should be sent to Firebase Crashlytics.
  bool _isAnError(LogsLevel level) => switch (level) {
        LogsLevel.trace ||
        LogsLevel.debug ||
        LogsLevel.info ||
        LogsLevel.warn ||
        LogsLevel.none =>
          false,
        LogsLevel.error || LogsLevel.fatal => true,
      };

  /// Add the log to the last logs if needed.
  void _addLastLogsIfNeeded({
    required LogsLevel level,
    // We use dynamic here to be able to log any type of message
    // ignore: avoid_annotating_with_dynamic
    dynamic message,
    List<String> categories = const [],
    StackTrace? stackTrace,
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception,
  }) {
    if (includeLastLogsNb == null || includeLastLogsNb! <= 0) {
      // We don't need to keep the last logs.
      return;
    }

    if (level.index < includeLastLogsMinLevel.index) {
      // We don't want to keep this log because its level is too low.
      return;
    }

    // We remove the first logs if the list is too long to accept a new log.
    final rangeToRemove = _lastLogs.length - includeLastLogsNb! + 1;
    if (rangeToRemove > 0) {
      _lastLogs.removeRange(0, rangeToRemove);
    }

    // We add the new log.
    // If there are multiple lines we join them with a `\n` because the case is rare and we don't
    // want to have partial information in the logs sent to Crashlytics.
    _lastLogs.add(LogFormatUtility.formatLogMessages(
      message: message,
      categories: categories,
      level: level,
      stackTrace: stackTrace,
      exception: exception,
    ).join("\n"));
  }

  /// Fire an error to Firebase Crashlytics.
  ///
  /// Before sending the error, we send the last logs to Firebase Crashlytics.
  Future<void> _fireError({
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    required dynamic exception,
    required LogsLevel level,
    StackTrace? stackTrace,
    List<String> categories = const [],
  }) async {
    // Because log method is asynchronous, we can't be sure that new log can't be added before the
    // error is fired. That's why we make a copy of the current logs.
    final currentLogs = List<String>.from(_lastLogs, growable: false);
    // We clear the logs to avoid having the same logs in the next error.
    _lastLogs.clear();
    for (final log in currentLogs) {
      await FirebaseCrashlytics.instance.log(log);
    }

    await FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      fatal: level == LogsLevel.fatal,
      information: [
        "Level: ${level.name.toLowerCase()}",
        if (categories.isNotEmpty) "Categories: ${LogFormatUtility.formatCategories(categories)}",
      ],
    );
  }

  /// {@macro bro_abstract_logger.MixinExternalLogger.dispose}
  @override
  Future<void> dispose() async {}
}
