// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import '../mixins/mixin_life_cycle_status.dart';
import 'd_manager.dart';

/// Build a new [EManager].
class EManagerBuilder extends AbsManagerBuilder<EManager> {
  /// Create a new [EManagerBuilder].
  const EManagerBuilder() : super(EManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [DManager];
}

/// A simple manager for the test.
class EManager extends AbsWithLifeCycle with MixinLifeCycleStatus {}
