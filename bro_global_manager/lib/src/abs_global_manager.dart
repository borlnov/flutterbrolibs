// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_global_manager/src/types/global_manager_status.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Get the manager of type [Manager] from the global manager.
Manager globalGetManager<Manager extends AbsWithLifeCycle>() =>
    AbsGlobalManager.absInstance!._getIt.get<Manager>();

/// This is an abstract class to build the global manager of the application.
///
/// We use [GetIt] package to manage the managers.
abstract class AbsGlobalManager extends AbsWithLifeCycle {
  /// The singleton instance of the global manager.
  static AbsGlobalManager? _instance;

  /// Get the singleton instance of the global manager. This returns a [AbsGlobalManager] type and not the subclass.
  /// This is only used with other bro packages.
  ///
  /// The instance must be created before using this getter.
  static AbsGlobalManager? get absInstance => _instance;

  /// Set the singleton instance of the global manager.
  @protected
  static void setInstance<T extends AbsGlobalManager>(T instance) {
    if (_instance != null) {
      // Nothing to do
      return;
    }
    _instance = instance;
  }

  /// Get the singleton instance of the global manager casted to the subclass.
  @protected
  static T getCastedInstance<T extends AbsGlobalManager>() => absInstance! as T;

  /// The [GetIt] instance used to manage the managers.
  final GetIt _getIt;

  /// The current status of the global manager.
  GlobalManagerStatus _currentStatus;

  /// Get the current status of the global manager.
  GlobalManagerStatus get currentStatus => _currentStatus;

  /// Class constructor.
  AbsGlobalManager()
      : _getIt = GetIt.instance,
        _currentStatus = GlobalManagerStatus.created;

  /// Initialize the lifecycle of the global manager.
  ///
  /// We set it to abstract to force the subclass to implement it.
  ///
  /// {@macro AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle();

  /// Initialize the lifecycle, after the first is built, of all the managers of the global manager.
  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    _currentStatus = GlobalManagerStatus.initializingAfterFirstViewBuilt;
    await super.initAfterViewBuilt(context);

    final managers = _getIt.getAll<AbsWithLifeCycle>();
    await Future.wait(managers.map((manager) => manager.initAfterViewBuilt(context)));
    _currentStatus = GlobalManagerStatus.ready;
  }

  /// Register a manager with a builder.
  void registerManagerWithBuilder<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(
    B builder,
  ) =>
      _getIt.registerSingletonAsync<M>(
        builder.build,
        dependsOn: builder.getDependencies(),
        dispose: builder.disposeManager,
      );

  /// Dispose the global manager and all the linked managers.
  @override
  Future<void> disposeLifeCycle() async {
    _currentStatus = GlobalManagerStatus.disposing;

    // By reseting the get it instance, we dispose all the managers.
    await _getIt.reset();

    return super.disposeLifeCycle();
  }
}
