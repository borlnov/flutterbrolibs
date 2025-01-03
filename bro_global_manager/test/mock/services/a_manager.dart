// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import '../mixins/mixin_life_cycle_status.dart';
import 'b_manager.dart';

/// Build a new [AManager].
class AManagerBuilder extends AbsManagerBuilder<AManager> {
  /// Create a new [AManagerBuilder].
  const AManagerBuilder() : super(AManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [BManager];
}

/// A simple manager for the test.
class AManager extends AbsWithLifeCycle with MixinLifeCycleStatus {}
