// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';

/// This is an abstract class to use as base for all the services, managers and generic classes
/// which needs to have a lifecycle.
abstract class AbsWithLifeCycle {
  /// {@template AbsWithLifeCycle.initLifeCycle}
  /// Called when the application is initializing.
  ///
  /// Be careful, the view is not yet built.
  /// {@endtemplate}
  @mustCallSuper
  Future<void> initLifeCycle() async {}

  /// {@template AbsWithLifeCycle.initAfterViewBuilt}
  /// Called after the first view is built.
  ///
  /// This is only called once.
  /// {@endtemplate}
  @mustCallSuper
  Future<void> initAfterViewBuilt(BuildContext context) async {}

  /// {@template AbsWithLifeCycle.disposeLifeCycle}
  /// Called when the application is disposing.
  /// {@endtemplate}
  @mustCallSuper
  Future<void> disposeLifeCycle() async {}
}