// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_logger_manager/src/models/log_message.dart';
import 'package:bro_logger_manager/src/types/log_level_extension.dart';
import 'package:logger/logger.dart';

/// This class is a custom log printer that allows to print logs with a custom format.
class MyLogPrinter extends LogPrinter {
  /// Transform the [event] into a list of strings.
  @override
  List<String> log(LogEvent event) {
    var messageContent = event.message;
    final categories = <String>[];
    if (messageContent is LogMessage) {
      categories.addAll(messageContent.categories);
      messageContent = messageContent.message;
    }

    return LogFormatUtility.formatLogMessages(
      message: messageContent,
      exception: event.error,
      stackTrace: event.stackTrace,
      categories: categories,
      level: event.level.logsLevel,
      time: event.time,
    );
  }
}
