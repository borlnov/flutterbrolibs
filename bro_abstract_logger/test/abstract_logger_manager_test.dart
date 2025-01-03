// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/helpers/test_print_logger.dart';
import 'mock/models/test_log_model.dart';
import 'mock/services/a_logger_manager.dart';

/// Test the [AbstractLoggerManager] behaviours.
void main() {
  test('Create LoggerManager', () async {
    // Test the AbstractLoggerManager class
    final builder = ALoggerBuilder();

    final manager = await builder.build();

    expect(manager, isNotNull);
  });

  test('Log before LoggerManager init', () {
    final testPrintLogger = TestPrintLogger();
    final manager = ALoggerManager.fromLoggerHelper(
      loggerHelper: LoggerHelper(
        logger: testPrintLogger,
      ),
    );

    const log1 = TestLogModel(
      message: 'Test log 1',
      level: LogsLevel.info,
    );
    const log2 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.error,
    );

    manager.loggerHelper.log(log1.level, log1.message);
    manager.loggerHelper.log(log2.level, log2.message);

    expect(testPrintLogger.logs.length, 2, reason: 'Test if the logs have been added');
    expect(testPrintLogger.logs[0], log1, reason: 'Test if the first log is correct');
    expect(testPrintLogger.logs[1], log2, reason: 'Test if the second log is correct');
  });

  test('Log after LoggerManager init', () async {
    final manager = ALoggerManager.fromLoggerHelper(
      loggerHelper: LoggerHelper(
        logger: TestPrintLogger(),
      ),
    );

    await manager.initLifeCycle();

    const log1 = TestLogModel(
      message: 'Test log 3',
      level: LogsLevel.info,
    );
    const log2 = TestLogModel(
      message: 'Test log 4',
      level: LogsLevel.error,
    );

    manager.loggerHelper.log(log1.level, log1.message);
    manager.loggerHelper.log(log2.level, log2.message);

    final testPrintLogger = manager.loggerHelper.logger as TestPrintLogger;

    expect(testPrintLogger.logs.length, 2, reason: 'Test if the logs have been added');
    expect(testPrintLogger.logs[0], log1, reason: 'Test if the first log is correct');
    expect(testPrintLogger.logs[1], log2, reason: 'Test if the second log is correct');
  });
}
