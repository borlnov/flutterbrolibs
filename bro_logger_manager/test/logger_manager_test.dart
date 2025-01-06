// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:bro_logger_manager/bro_logger_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/services/global_manager.dart';

/// Test the logger manager
void main() {
  test('Test logger manager print to console', () async {
    await GlobalManager.instance.initLifeCycle();
    final loggerManager = globalGetManager<LoggerManager>();

    expect(
      () => loggerManager.loggerHelper.info('Test log'),
      prints(matches("[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}Z "
          r'- \[info\]: Test log\n')),
      reason: "Expect to print the log",
    );
  });
}
