// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/services/a_manager.dart';
import 'mock/services/a_manager_builder.dart';
import 'mock/types/manager_status.dart';

/// Test the abstract manager builder.
void main() {
  test("Test the abstract manager builder", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.irrelevant],
      platformBehavior: WrongPlatformBehavior.throwError,
    );
    final manager = await builder.build();

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });

  test("Test reuse manager", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.irrelevant],
      platformBehavior: WrongPlatformBehavior.throwError,
    );
    final tmpManager = AManager();
    final manager = await builder.build(
      managerToInit: tmpManager,
    );

    expect(
      manager,
      tmpManager,
      reason: "The manager got should be the same as the one passed in parameter",
    );
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });

  test("Test supported one platform", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.android],
      platformBehavior: WrongPlatformBehavior.throwError,
    );
    final manager = await builder.build(
      currentPlatform: PlatformType.android,
    );

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });

  test("Test supported multiples platform", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.android, PlatformType.iOS],
      platformBehavior: WrongPlatformBehavior.throwError,
    );
    final manager = await builder.build(
      currentPlatform: PlatformType.android,
    );

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });

  test("Test not supported platform, doesn't init", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.iOS],
      platformBehavior: WrongPlatformBehavior.doNotInitManager,
    );
    final manager = await builder.build(
      currentPlatform: PlatformType.android,
    );

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.created,
      reason: "The manager should be created after build",
    );
  });

  test("Test not supported platform, continue process", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.iOS],
      platformBehavior: WrongPlatformBehavior.continueProcess,
    );
    final manager = await builder.build(
      currentPlatform: PlatformType.android,
    );

    expect(manager, isNotNull, reason: "The manager should not be null after build");
    expect(
      manager.status,
      ManagerStatus.initialized,
      reason: "The manager should be initialized after build",
    );
  });

  test("Test not supported platform, throw error", () async {
    final builder = const AManagerBuilder(
      supportedPlatforms: [PlatformType.iOS],
      platformBehavior: WrongPlatformBehavior.throwError,
    );

    await expectLater(
      builder.build(
        currentPlatform: PlatformType.android,
      ),
      throwsA(isA<PlatformNotSupportedByManagerError>()),
      reason: "The build has thrown an error",
    );
  });
}
