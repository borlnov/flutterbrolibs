// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/helpers/test_print_logger.dart';
import 'mock/models/test_log_model.dart';
import 'mock/services/a_logger_manager.dart';
import 'mock/services/b_multi_logger_manager.dart';

/// Test the [AbstractMultiLoggerManager] behaviours.
void main() {
  test('Create MultiLoggerManager', () async {
    final builder = BMultiBuilder(loggersBuilders: [
      ALoggerBuilder(),
      ALoggerBuilder(),
    ]);

    final manager = await builder.build();

    expect(manager, isNotNull);
  });

  test('Log before MultiLoggerManager init', () {
    final testPrintALogger = TestPrintLogger();
    final testPrintBLogger = TestPrintLogger();

    final multiManager = BMultiLoggerManager([
      ALoggerManager.fromLoggerHelper(
        loggerHelper: LoggerHelper(
          logger: testPrintALogger,
        ),
      ),
      ALoggerManager.fromLoggerHelper(
        loggerHelper: LoggerHelper(
          logger: testPrintBLogger,
        ),
      ),
    ]);

    const log1 = TestLogModel(
      message: 'Test log 1',
      level: LogsLevel.info,
    );
    const log2 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.error,
    );

    multiManager.loggerHelper.log(log1.level, log1.message);
    multiManager.loggerHelper.log(log2.level, log2.message);

    expect(testPrintALogger.logs.length, 2, reason: 'Test if the logs have been added in logger A');
    expect(testPrintALogger.logs[0], log1, reason: 'Test if the first log is correct in logger A');
    expect(testPrintALogger.logs[1], log2, reason: 'Test if the second log is correct in logger A');

    expect(testPrintBLogger.logs.length, 2, reason: 'Test if the logs have been added in logger B');
    expect(testPrintBLogger.logs[0], log1, reason: 'Test if the first log is correct in logger B');
    expect(testPrintBLogger.logs[1], log2, reason: 'Test if the second log is correct in logger B');
  });

  test('Log after MultiLoggerManager init', () async {
    final managerA = ALoggerManager.fromLoggerHelper(
      loggerHelper: LoggerHelper(
        logger: TestPrintLogger(),
      ),
    );
    final managerB = ALoggerManager.fromLoggerHelper(
      loggerHelper: LoggerHelper(
        logger: TestPrintLogger(),
      ),
    );

    final multiManager = BMultiLoggerManager([
      managerA,
      managerB,
    ]);

    await multiManager.initLifeCycle();

    const log1 = TestLogModel(
      message: 'Test log 1',
      level: LogsLevel.info,
    );
    const log2 = TestLogModel(
      message: 'Test log 2',
      level: LogsLevel.error,
    );

    final testPrintALogger = managerA.loggerHelper.logger as TestPrintLogger;
    final testPrintBLogger = managerB.loggerHelper.logger as TestPrintLogger;

    multiManager.loggerHelper.log(log1.level, log1.message);
    multiManager.loggerHelper.log(log2.level, log2.message);

    expect(testPrintALogger.logs.length, 2, reason: 'Test if the logs have been added in logger A');
    expect(testPrintALogger.logs[0], log1, reason: 'Test if the first log is correct in logger A');
    expect(testPrintALogger.logs[1], log2, reason: 'Test if the second log is correct in logger A');

    expect(testPrintBLogger.logs.length, 2, reason: 'Test if the logs have been added in logger B');
    expect(testPrintBLogger.logs[0], log1, reason: 'Test if the first log is correct in logger B');
    expect(testPrintBLogger.logs[1], log2, reason: 'Test if the second log is correct in logger B');
  });
}
