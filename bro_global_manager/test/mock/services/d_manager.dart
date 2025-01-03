// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import '../mixins/mixin_life_cycle_status.dart';
import 'e_manager.dart';

/// Build a new [DManager].
class DManagerBuilder extends AbsManagerBuilder<DManager> {
  /// Create a new [DManagerBuilder].
  const DManagerBuilder() : super(DManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [EManager];
}

/// A simple manager for the test.
class DManager extends AbsWithLifeCycle with MixinLifeCycleStatus {}
