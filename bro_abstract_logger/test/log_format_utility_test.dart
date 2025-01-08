// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test the [LogFormatUtility] class.
void main() {
  group("Test formatLogMessages method", () {
    test('Test different exporting', () async {
      final time = DateTime.now().toUtc();
      expect(
        LogFormatUtility.formatLogMessages(
          level: LogsLevel.info,
          categories: ['default', "other"],
          message: 'Test log',
          time: time,
        ),
        [
          '${time.toIso8601String()} - [info] [default/other]: Test log',
        ],
        reason: "Test one message line",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          level: LogsLevel.info,
          message: 'Test log',
          time: time,
        ),
        [
          '${time.toIso8601String()} - [info]: Test log',
        ],
        reason: "Test one message line without categories",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          categories: ['default', "other"],
          message: 'Test log',
          time: time,
        ),
        [
          '${time.toIso8601String()} - [default/other]: Test log',
        ],
        reason: "Test one message line without level",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          message: 'Test log',
          time: time,
        ),
        [
          '${time.toIso8601String()}: Test log',
        ],
        reason: "Test one message line without level",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          level: LogsLevel.info,
          categories: ['default', "other"],
          message: 'Test log',
        ),
        [
          '[info] [default/other]: Test log',
        ],
        reason: "Test one message line without time",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          level: LogsLevel.info,
          message: 'Test log',
        ),
        [
          '[info]: Test log',
        ],
        reason: "Test one message line without time and categories",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          categories: ['default', "other"],
          message: 'Test log',
        ),
        [
          '[default/other]: Test log',
        ],
        reason: "Test one message line without time and level",
      );
      expect(
        LogFormatUtility.formatLogMessages(
          message: 'Test log',
        ),
        [
          'Test log',
        ],
        reason: "Test one message line with only the message",
      );
    });
    test('Test different exporting with exception and stacktrace', () async {
      final time = DateTime.now().toUtc();
      final currentStackTrace = StackTrace.current;
      expect(
        LogFormatUtility.formatLogMessages(
          level: LogsLevel.info,
          categories: ['default', "other"],
          message: 'Test log',
          time: time,
          exception: Exception('Test exception'),
          stackTrace: currentStackTrace,
        ),
        [
          '${time.toIso8601String()} - [info] [default/other]: Test log',
          '${time.toIso8601String()} - [info] [default/other]: Exception: Test exception',
          '${time.toIso8601String()} - [info] [default/other]: $currentStackTrace',
        ],
        reason: "Test one message line",
      );
    });
  });
}
