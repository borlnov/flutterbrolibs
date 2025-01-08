// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/bro_abstract_manager.dart';

import 'a_manager.dart';

/// This is the builder to create the [AManager].
class AManagerBuilder extends AbsManagerBuilder<AManager> {
  final WrongPlatformBehavior platformBehavior;
  final List<PlatformType> supportedPlatforms;

  const AManagerBuilder({
    required this.supportedPlatforms,
    required this.platformBehavior,
  });

  /// {@macro bro_abstract_manager.AbsManagerBuilder.create}
  @override
  AManager create() => AManager();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getWrongPlatformBehavior}
  @override
  WrongPlatformBehavior getWrongPlatformBehavior() => platformBehavior;

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getSupportedPlatforms}
  @override
  List<PlatformType> getSupportedPlatforms() => supportedPlatforms;
}
