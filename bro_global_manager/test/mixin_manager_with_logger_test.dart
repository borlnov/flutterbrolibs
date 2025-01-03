// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/services/c_global_manager.dart';

void main() {
  // Test the mixin manager with logger
  test('Test the mixin manager with logger', () async {
    await expectLater(
      CGlobalManager.instance.initLifeCycle,
      prints(matches("[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}Z "
          r'- \[info\] \[default\]: GManager is initialized\n')),
      reason: "Expect to print the log",
    );

    AbsGlobalManager.resetSingleton();
  });
}
