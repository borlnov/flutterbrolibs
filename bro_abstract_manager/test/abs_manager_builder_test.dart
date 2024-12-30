// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'struct/services/a_manager_builder.dart';
import 'struct/types/manager_status.dart';

/// Test the abstract manager builder.
void main() {
  test("Test the abstract manager builder", () async {
    final builder = AManagerBuilder();
    final manager = await builder.build();

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });
}
