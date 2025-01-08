// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/src/errors/platform_not_supported_by_manager_error.dart';
import 'package:bro_abstract_manager/src/services/abs_with_life_cycle.dart';
import 'package:bro_abstract_manager/src/types/wrong_platform_behavior.dart';
import 'package:bro_platform_utility/bro_platform_utility.dart';
import 'package:flutter/widgets.dart';

/// This is an abstract class to build a manager with a lifecycle.
///
/// This is used to build managers for get it package.
abstract class AbsManagerBuilder<Manager extends AbsWithLifeCycle> {
  /// Class constructor.
  const AbsManagerBuilder();

  /// {@template bro_abstract_manager.AbsManagerBuilder.create}
  /// Call this method to create a new manager.
  /// {@endtemplate}
  Manager create();

  /// {@template bro_abstract_manager.AbsManagerBuilder.build}
  /// Build the manager and call the [AbsWithLifeCycle.initLifeCycle] method.
  ///
  /// If the [managerToInit] is not null, it will be used instead of creating a new manager.
  /// The [currentPlatform] is used to check if the manager is supported on the current platform.
  /// If null, we try to guess the current platform.
  /// {@endtemplate}
  @mustCallSuper
  Future<Manager> build({
    Manager? managerToInit,
    PlatformType? currentPlatform,
  }) async {
    final isPlatformManaged =
        _isManagerCanBeInitializedWithCurrentPlatform(currentPlatform: currentPlatform);
    final manager = managerToInit ?? create();
    if (!isPlatformManaged) {
      // The platform is not managed by the manager, so we don't init it.
      return manager;
    }

    await manager.initLifeCycle();
    return manager;
  }

  /// {@template bro_abstract_manager.AbsManagerBuilder.getDependencies}
  /// Get the dependencies of the manager.
  ///
  /// [Type] is the type of the dependencies and must be a subclass of [AbsWithLifeCycle].
  /// {@endtemplate}
  @mustCallSuper
  Iterable<Type> getDependencies();

  /// {@template bro_abstract_manager.AbsManagerBuilder.getSupportedPlatforms}
  /// Get the platforms supported by the manager.
  ///
  /// If the list contains [PlatformType.irrelevant], the manager is supported on all platforms.
  ///
  /// The behavior of the manager building on an unsupported platform is defined by the
  /// [getWrongPlatformBehavior] method. This is used when we [build] the manager.
  /// {@endtemplate}
  List<PlatformType> getSupportedPlatforms() => const [PlatformType.irrelevant];

  /// {@template bro_abstract_manager.AbsManagerBuilder.getWrongPlatformBehavior}
  /// Get the behavior of the manager building on an unsupported platform.
  /// {@endtemplate}
  WrongPlatformBehavior getWrongPlatformBehavior() => WrongPlatformBehavior.throwError;

  /// {@template bro_abstract_manager.AbsManagerBuilder.isPlatformSupported}
  /// Check if the current platform is supported by the manager.
  /// {@endtemplate}
  bool isPlatformSupported({
    PlatformType? currentPlatform,
  }) {
    final supportedPlatforms = getSupportedPlatforms();
    return PlatformType.isCurrentSupported(
      currentPlatform: currentPlatform,
      supportedPlatforms: supportedPlatforms,
    );
  }

  /// The method checks if the manager can be initialized with the current platform.
  ///
  /// If not, the [WrongPlatformBehavior] is used to determine the behavior of the manager building.
  ///
  /// The method throws an Error if the platform is not supported at all.
  ///
  /// The method returns false if the manager can be created but not initialized. This is used to
  /// avoid calling the [AbsWithLifeCycle.initLifeCycle] method on an unsupported platform.
  /// The method returns true if the manager can be created and initialized.
  bool _isManagerCanBeInitializedWithCurrentPlatform({
    required PlatformType? currentPlatform,
  }) {
    final isCurrentlySupported = isPlatformSupported(currentPlatform: currentPlatform);
    if (isCurrentlySupported) {
      return true;
    }

    final wrongPlatformBehavior = getWrongPlatformBehavior();
    switch (wrongPlatformBehavior) {
      case WrongPlatformBehavior.throwError:
        throw PlatformNotSupportedByManagerError(
          currentPlatform: currentPlatform!,
          supportedPlatforms: getSupportedPlatforms(),
        );
      case WrongPlatformBehavior.doNotInitManager:
        return false;
      case WrongPlatformBehavior.continueProcess:
        return true;
    }
  }
}
