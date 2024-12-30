// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/widgets.dart';

import '../types/manager_status.dart';

/// This is a test manager.
class AManager extends AbsWithLifeCycle {
  /// The status of the manager.
  ManagerStatus status;

  /// Create the [AManager].
  AManager() : status = ManagerStatus.created;

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    status = ManagerStatus.initialized;
  }

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initAfterViewBuilt}
  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    await super.initAfterViewBuilt(context);
    status = ManagerStatus.afterBuilt;
  }

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.disposeLifeCycle}
  @override
  Future<void> disposeLifeCycle() async {
    await super.disposeLifeCycle();
    status = ManagerStatus.disposed;
  }
}
