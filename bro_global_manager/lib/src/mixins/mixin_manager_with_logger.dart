// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_global_manager/src/services/abs_global_manager.dart';
import 'package:flutter/foundation.dart';

/// A mixin that adds a logger to a manager.
///
/// This is useful when you want to easily create a logger for a manager.
mixin MixinManagerWithLogger on AbsWithLifeCycle {
  /// The logger of the manager.
  ///
  /// The logger is set during the initialization of the manager.
  late LoggerHelper logger;

  /// This is the parent logger to use to create the manager logger from it.
  ///
  /// By default, the parent logger is the main app logger.
  LoggerHelper _parentLogger = AbsGlobalManager.absInstance!.appLoggerHelper;

  /// This method can be used in the manager initialization before calling [super.initLifeCycle] to
  /// set the parent logger to use to create the manager logger.
  ///
  /// By default, the parent logger is the main app logger.
  @protected
  set parentLogger(LoggerHelper value) {
    _parentLogger = value;
  }

  /// This method can be overridden to set the category of the manager logger.
  ///
  /// By default, the [logger] will have no category.
  @protected
  String? get logCategory => null;

  /// This method can be overridden to set the minimum level of the manager logger.
  ///
  /// By default, the [logger] will have no minimum level.
  @protected
  LogsLevel? get logMinLevel => null;

  /// This method initializes the logger of the manager.
  ///
  /// If you want to update the [_parentLogger], you can do it by overriding this method and calls
  /// [parentLogger] setter before calling [super.initLifeCycle].
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();

    logger = _parentLogger.createSubLogger(
      category: logCategory,
      minLevel: logMinLevel,
    );
  }
}
