// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_global_manager/src/models/manager_registering_dead_loop_error.dart';
import 'package:bro_global_manager/src/types/global_manager_status.dart';
import 'package:flutter/widgets.dart';

/// Type to register a manager with a builder.
typedef _RegistrationBuilders = Map<AbsManagerBuilder, Future<void> Function()>;

/// Get the manager of type [Manager] from the global manager.
Manager globalGetManager<Manager extends AbsWithLifeCycle>() =>
    AbsGlobalManager.absInstance!.getManager<Manager>();

/// Get the main logger helper from the global manager.
LoggerHelper appLoggerHelper() => AbsGlobalManager.absInstance!.appLoggerHelper;

/// This is an abstract class to build the global manager of the application.
abstract class AbsGlobalManager extends AbsWithLifeCycle {
  /// The singleton instance of the global manager.
  static AbsGlobalManager? _instance;

  /// Get the singleton instance of the global manager. This returns a [AbsGlobalManager] type and
  /// not the subclass.
  /// This is only used with other bro packages.
  ///
  /// The instance must be created before using this getter.
  static AbsGlobalManager? get absInstance => _instance;

  /// Get the singleton instance of the global manager casted to the subclass.
  @protected
  static T getCastedInstance<T extends AbsGlobalManager>(T Function() factory) {
    _instance ??= factory();
    return _instance! as T;
  }

  /// The list of all the managers of the global manager.
  final Map<Type, AbsWithLifeCycle> _managers;

  /// The current status of the global manager.
  GlobalManagerStatus _currentStatus;

  /// Get the current status of the global manager.
  GlobalManagerStatus get currentStatus => _currentStatus;

  /// The main logger manager of the application.
  late final AbstractLoggerManager _loggerManager;

  /// Get the main logger helper of the application.
  LoggerHelper get appLoggerHelper => _loggerManager.loggerHelper;

  /// Class constructor.
  AbsGlobalManager()
      : _currentStatus = GlobalManagerStatus.created,
        _managers = {};

  /// Initialize the lifecycle of the global manager and all the linked managers.
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();

    final builders = _RegistrationBuilders();
    registerManagers(<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder) =>
        _registerManagerWithBuilder<M, B>(
          builder: builder,
          builders: builders,
        ));

    _registerVoidLoggerIfNeeded(builders: builders);

    await _initManagers(builders);

    _currentStatus = GlobalManagerStatus.initialized;
  }

  /// Initialize the lifecycle, after the first is built, of all the managers of the global manager.
  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    await super.initAfterViewBuilt(context);

    await Future.wait(_managers.values.map((value) => value.initAfterViewBuilt(context)));
    _currentStatus = GlobalManagerStatus.ready;
  }

  /// Get the manager of type [Manager] from the global manager.
  Manager getManager<Manager extends AbsWithLifeCycle>() => _managers[Manager]! as Manager;

  /// {@template abs_global_manager.AbsGlobalManager.registerManagers}
  /// Register all the managers of the global manager.
  ///
  /// This method must be implemented in the subclass to register all the managers of the global
  /// manager.
  ///
  /// The implementation must call the [registerManager] function with the builder of the manager to
  /// register.
  ///
  /// Call the [registerManager] function with the explicit type of the manager and the builder.
  ///
  /// DON'T (event if it builds)
  /// ```dart
  /// registerManager(const AManagerBuilder());
  /// ```
  ///
  /// DO
  /// ```dart
  /// registerManager<AManager, AManagerBuilder>(const AManagerBuilder());
  /// ```
  ///
  /// With this global manager, you can only register one manager of each type.
  /// {@endtemplate}
  @protected
  void registerManagers(
    void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(
      B builder,
    ) registerManager,
  );

  /// Register a manager with a builder.
  void _registerManagerWithBuilder<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>({
    required B builder,
    required _RegistrationBuilders builders,
  }) {
    M? manager;
    if (builder is AbsLoggerBuilder) {
      manager = builder.managerFactory();
      _loggerManager = manager as AbstractLoggerManager;
    }

    builders[builder] = () async {
      final tmpManager = await builder.build(managerToInit: manager);
      _managers[M] = tmpManager;
    };
  }

  /// Register a void logger manager if no logger manager has been registered.
  ///
  /// This is used to prevent the app to crash if no logger manager has been registered.
  void _registerVoidLoggerIfNeeded({
    required _RegistrationBuilders builders,
  }) {
    for (final entry in builders.entries) {
      if (entry.key is AbsLoggerBuilder) {
        return;
      }
    }

    // No logger manager has been registered, we register a void logger manager to prevent the
    // app to crash
    _registerManagerWithBuilder<VoidLoggerManager, VoidLoggerBuilder>(
      builder: const VoidLoggerBuilder(),
      builders: builders,
    );
  }

  /// Initialize the managers of the global manager.
  ///
  /// This method is called recursively to register all the managers of the global manager. It
  /// looks for the dependencies of the managers to register them in the right order.
  Future<void> _initManagers(
    _RegistrationBuilders buildersToRegister,
  ) async {
    final registeredLength = _managers.length;
    final tmpBuilders = _RegistrationBuilders.from(buildersToRegister);
    final toRemoveBuilders = <AbsManagerBuilder>[];

    for (final entry in tmpBuilders.entries) {
      final builder = entry.key;
      final register = entry.value;

      final dependencies = builder.getDependencies();
      var canRegister = true;
      for (final dependency in dependencies) {
        if (!_managers.keys.any((value) => value == dependency)) {
          // The dependency is not registered, we stop here
          canRegister = false;
          break;
        }
      }

      if (!canRegister) {
        continue;
      }

      toRemoveBuilders.add(builder);
      await register();
    }

    toRemoveBuilders.forEach(tmpBuilders.remove);

    if (tmpBuilders.isEmpty) {
      // All has been registered, nothing more to do
      return;
    }

    if (registeredLength == _managers.length) {
      // No new manager has been registered, we are in a dead loop
      throw ManagerRegisteringDeadLoopError();
    }

    return _initManagers(tmpBuilders);
  }

  /// Dispose the global manager and all the linked managers.
  @override
  Future<void> disposeLifeCycle() async {
    _currentStatus = GlobalManagerStatus.disposing;

    // By reseting the get it instance, we dispose all the managers.
    await Future.wait(_managers.values.map((value) => value.disposeLifeCycle()));
    _managers.clear();

    return super.disposeLifeCycle();
  }
}
