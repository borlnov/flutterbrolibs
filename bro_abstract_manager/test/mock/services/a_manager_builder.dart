// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import 'a_manager.dart';

/// This is the builder to create the [AManager].
class AManagerBuilder extends AbsManagerBuilder<AManager> {
  /// Create the [AManagerBuilder].
  AManagerBuilder() : super(AManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}
