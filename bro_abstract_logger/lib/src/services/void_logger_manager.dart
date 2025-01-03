// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// This class is used to build a [VoidLoggerManager].
class VoidLoggerBuilder extends AbsLoggerBuilder<VoidLoggerManager> {
  /// Class constructor.
  const VoidLoggerBuilder() : super(VoidLoggerManager.new);

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// This class is a logger manager that does nothing.
class VoidLoggerManager extends AbstractLoggerManager {
  /// Class constructor.
  VoidLoggerManager()
      : super(
          printLogsByDefault: false,
        );

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async => VoidPrintLogger.instance;
}
