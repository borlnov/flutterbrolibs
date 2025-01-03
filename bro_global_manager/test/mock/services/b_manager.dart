// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import '../mixins/mixin_life_cycle_status.dart';

/// Build a new [BManager].
class BManagerBuilder extends AbsManagerBuilder<BManager> {
  /// Create a new [BManagerBuilder].
  const BManagerBuilder() : super(BManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// A simple manager for the test.
class BManager extends AbsWithLifeCycle with MixinLifeCycleStatus {}
