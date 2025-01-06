// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_logger_manager/src/models/log_message.dart';
import 'package:bro_logger_manager/src/types/log_level_extension.dart';
import 'package:logger/logger.dart';

/// This class is a custom log printer that allows to print logs with a custom format.
class MyLogPrinter extends LogPrinter {
  /// The default separator used to separate the categories.
  static const _defaultCategorySeparator = ".";

  /// Transform the [event] into a list of strings.
  @override
  List<String> log(LogEvent event) {
    var messageContent = event.message;
    final categories = <String>[];
    if (messageContent is LogMessage) {
      categories.addAll(messageContent.categories);
      messageContent = messageContent.message;
    }

    var message = "${DateTime.now().toUtc().toIso8601String()} - "
        "[${event.level.logsLevel.name.toLowerCase()}]";

    if (categories.isNotEmpty) {
      message += " [${categories.join(_defaultCategorySeparator)}]";
    }

    message += ": $messageContent";

    return [
      message,
      if (event.error != null) "Error: ${event.error}",
      if (event.stackTrace != null) "Stack trace: ${event.stackTrace}",
    ];
  }
}
