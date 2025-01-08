// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// This is a utility class that provides methods to format log messages.
abstract final class LogFormatUtility {
  /// This is the separator used to separate categories in the log message.
  static const String categorySeparator = "/";

  /// This method formats the categories into a string.
  static String formatCategories(List<String> categories) => categories.join(categorySeparator);

  /// This method formats the log messages into a list of strings which can be logged by an
  /// external logger.
  ///
  /// The [message] is the main message to log. The [exception] and [stackTrace] are optional and
  /// will be logged if provided in different lines
  /// The other parameters are used to add more context to the log message.
  /// If one of the parameters is null, it will be ignored in the displayed lines.
  ///
  /// The format is the following:
  ///
  /// - [time] - [level] [categories]: [message]
  /// - [time] - [level] [categories]: [exception] (_optional_)
  /// - [time] - [level] [categories]: [stackTrace] (_optional_)
  ///
  /// The prefix can be:
  ///
  /// - [time] - [level] [categories]:
  /// - [time] - [level]:
  /// - [time] - [categories]:
  /// - [time]:
  /// - [level] [categories]:
  /// - [level]:
  /// - [categories]:
  ///
  /// Example with all paramters:
  ///
  /// > 2025-01-08T11:50:38.470987Z - [info] [default/other]: Global manager initialized.
  static List<String> formatLogMessages({
    // We use dynamic here to be able to log any type of message
    // ignore: avoid_annotating_with_dynamic
    dynamic message,
    List<String> categories = const [],
    LogsLevel? level,
    DateTime? time,
    StackTrace? stackTrace,
    // We use dynamic here to be able to log any type of exception
    // ignore: avoid_annotating_with_dynamic
    dynamic exception,
  }) {
    final prefixElems = <String>[];

    if (time != null) {
      prefixElems.add(time.toUtc().toIso8601String());
      prefixElems.add("-");
    }

    if (level != null) {
      prefixElems.add("[${level.name.toLowerCase()}]");
    }

    if (categories.isNotEmpty) {
      prefixElems.add("[${formatCategories(categories)}]");
    }

    final prefixLength = prefixElems.length;
    var prefixMsg = "";
    if (prefixLength > 0) {
      if (time != null && prefixLength == 2) {
        // We remove the time padding to avoid having a space or a glyph before the message.
        prefixElems.removeLast();
      }

      prefixMsg = "${prefixElems.join(" ")}: ";
    }

    return [
      if (message != null) "$prefixMsg$message",
      if (exception != null) "$prefixMsg$exception",
      if (stackTrace != null) "$prefixMsg$stackTrace",
    ];
  }
}
