// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/models/fake_build_context.dart';
import 'mock/services/a_global_manager.dart';
import 'mock/services/a_manager.dart';
import 'mock/services/b_global_manager.dart';
import 'mock/services/b_manager.dart';
import 'mock/services/c_logger_manager.dart';
import 'mock/types/manager_status.dart';

/// Test the global manager.
void main() {
  test("Create and init a default global manager", () async {
    final globalManager = AGlobalManager();

    expect(globalManager, isNotNull, reason: "Expect to create the global manager");
    expect(globalManager.currentStatus, GlobalManagerStatus.created,
        reason: "Expect to have the status created");

    await expectLater(
      globalManager.initLifeCycle(),
      completes,
      reason: "Expect to init the global manager without error",
    );

    expect(globalManager.getManager<AManager>(), isNotNull, reason: "Expect to have the AManager");
    expect(globalManager.getManager<BManager>(), isNotNull, reason: "Expect to have the BManager");
    expect(globalManager.getManager<CLoggerManager>(), isNotNull,
        reason: "Expect to have the CLoggerManager");

    await globalManager.disposeLifeCycle();
  });

  test("Create and init a default global manager with a dead loop", () async {
    final globalManager = BGlobalManager();

    expect(globalManager, isNotNull, reason: "Expect to create the global manager");
    expect(globalManager.currentStatus, GlobalManagerStatus.created,
        reason: "Expect to have the status created");

    await expectLater(
      globalManager.initLifeCycle,
      throwsA(isA<ManagerRegisteringDeadLoopError>()),
      reason: "Expect to have a dead loop error",
    );

    await globalManager.disposeLifeCycle();
  });

  test("Test the managers status", () async {
    final globalManager = AGlobalManager();

    expect(globalManager.currentStatus, GlobalManagerStatus.created,
        reason: "Expect to have the status created");

    await globalManager.initLifeCycle();

    final aManager = globalManager.getManager<AManager>();
    final bManager = globalManager.getManager<BManager>();
    final cLoggerManager = globalManager.getManager<CLoggerManager>();

    expect(globalManager.currentStatus, GlobalManagerStatus.initialized,
        reason: "Expect to have the status initialized");
    expect(aManager.status, ManagerStatus.initialized,
        reason: "Expect to have the AManager initialized");
    expect(bManager.status, ManagerStatus.initialized,
        reason: "Expect to have the BManager initialized");
    expect(cLoggerManager.status, ManagerStatus.initialized,
        reason: "Expect to have the CLoggerManager initialized");

    await globalManager.initAfterViewBuilt(FakeBuildContext());

    expect(globalManager.currentStatus, GlobalManagerStatus.ready,
        reason: "Expect to have the status ready");
    expect(aManager.status, ManagerStatus.afterBuilt,
        reason: "Expect to have the AManager in afterBuilt status");
    expect(bManager.status, ManagerStatus.afterBuilt,
        reason: "Expect to have the BManager in afterBuilt status");
    expect(cLoggerManager.status, ManagerStatus.afterBuilt,
        reason: "Expect to have the CLoggerManager in afterBuilt status");

    await globalManager.disposeLifeCycle();

    expect(globalManager.currentStatus, GlobalManagerStatus.disposing,
        reason: "Expect to have the status disposing");
    expect(aManager.status, ManagerStatus.disposed,
        reason: "Expect to have the AManager in disposed status");
    expect(bManager.status, ManagerStatus.disposed,
        reason: "Expect to have the BManager in disposed status");
    expect(cLoggerManager.status, ManagerStatus.disposed,
        reason: "Expect to have the CLoggerManager in disposed status");
  });
}
