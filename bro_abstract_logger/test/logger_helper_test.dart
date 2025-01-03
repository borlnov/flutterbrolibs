// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/helpers/test_print_logger.dart';
import 'mock/models/test_log_model.dart';

/// Test the logger helper behaviours.
void main() {
  test('Test to print with default log helper', () {
    bool success;

    try {
      expect(
        () => DefaultPrintLogger.instance.info('Test log'),
        prints(matches("[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}Z "
            r'- \[info\] \[default\]: Test log\n')),
        reason: "Expect to print the log",
      );
      success = true;
    } catch (e) {
      success = false;
    }

    expect(success, true, reason: "Expect to have no crash");
  });

  group("Test the logger helper parameters", () {
    const log1 = TestLogModel(
      message: 'Test log 1',
      level: LogsLevel.trace,
    );
    const log2 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.debug,
    );
    const log3 = TestLogModel(
      message: 'Test log 1',
      level: LogsLevel.info,
    );
    const log4 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.warn,
    );
    const log5 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.error,
    );
    const log6 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.fatal,
    );
    const log7 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.none,
    );

    test('Test to print with categories', () async {
      const category = "Test";
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        category: category,
      );

      loggerHelper.trace(log1.message);

      expect(testPrintLogger.logs.length, 1, reason: 'Test if the log has been added');
      expect(
        testPrintLogger.logs[0].categories.length,
        1,
        reason: 'Verify the number of categories',
      );
      expect(
        testPrintLogger.logs[0].categories[0],
        category,
        reason: 'Verify the category used',
      );
    });

    test('Test to print with different levels', () async {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);
      loggerHelper.log(log7.level, log7.message);

      expect(testPrintLogger.logs.length, 6, reason: 'Test if the logs have been added');
      expect(testPrintLogger.logs[0], log1, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log2, reason: 'Test if the second log is correct');
      expect(testPrintLogger.logs[2], log3, reason: 'Test if the third log is correct');
      expect(testPrintLogger.logs[3], log4, reason: 'Test if the fourth log is correct');
      expect(testPrintLogger.logs[4], log5, reason: 'Test if the fifth log is correct');
      expect(testPrintLogger.logs[5], log6, reason: 'Test if the sixth log is correct');
    });

    test("Test if logger helper min level works: trace", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.trace,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 6, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log1, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log2, reason: 'Test if the second log is correct');
      expect(testPrintLogger.logs[2], log3, reason: 'Test if the third log is correct');
      expect(testPrintLogger.logs[3], log4, reason: 'Test if the fourth log is correct');
      expect(testPrintLogger.logs[4], log5, reason: 'Test if the fifth log is correct');
      expect(testPrintLogger.logs[5], log6, reason: 'Test if the sixth log is correct');
    });

    test("Test if logger helper min level works: debug", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.debug,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 5, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log2, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log3, reason: 'Test if the second log is correct');
      expect(testPrintLogger.logs[2], log4, reason: 'Test if the third log is correct');
      expect(testPrintLogger.logs[3], log5, reason: 'Test if the fourth log is correct');
      expect(testPrintLogger.logs[4], log6, reason: 'Test if the fifth log is correct');
    });

    test("Test if logger helper min level works: info", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.info,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 4, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log3, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log4, reason: 'Test if the second log is correct');
      expect(testPrintLogger.logs[2], log5, reason: 'Test if the third log is correct');
      expect(testPrintLogger.logs[3], log6, reason: 'Test if the fourth log is correct');
    });

    test("Test if logger helper min level works: warn", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.warn,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 3, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log4, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log5, reason: 'Test if the second log is correct');
      expect(testPrintLogger.logs[2], log6, reason: 'Test if the third log is correct');
    });

    test("Test if logger helper min level works: error", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.error,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 2, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log5, reason: 'Test if the first log is correct');
      expect(testPrintLogger.logs[1], log6, reason: 'Test if the second log is correct');
    });

    test("Test if logger helper min level works: fatal", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.fatal,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 1, reason: 'Test if the log has been added');
      expect(testPrintLogger.logs[0], log6, reason: 'Test if the first log is correct');
    });

    test("Test if logger helper min level works: none", () {
      final testPrintLogger = TestPrintLogger();
      final loggerHelper = LoggerHelper(
        logger: testPrintLogger,
        minLevel: LogsLevel.none,
      );

      loggerHelper.trace(log1.message);
      loggerHelper.debug(log2.message);
      loggerHelper.info(log3.message);
      loggerHelper.warn(log4.message);
      loggerHelper.error(log5.message);
      loggerHelper.fatal(log6.message);

      expect(testPrintLogger.logs.length, 0, reason: 'Test if the log has been added');
    });
  });
}
