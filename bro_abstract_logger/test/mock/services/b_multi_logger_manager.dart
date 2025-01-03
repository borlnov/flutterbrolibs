// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// This is the builder to create the [BMultiLoggerManager].
class BMultiBuilder extends AbsMultiLoggerBuilder<BMultiLoggerManager> {
  /// Create the [BMultiBuilder].
  BMultiBuilder({
    required super.loggersBuilders,
  }) : super(mainManagerFactory: BMultiLoggerManager.new);
}

/// This is the multi logger manager used to test the logging system.
class BMultiLoggerManager extends AbstractMultiLoggerManager {
  /// Create the [BMultiLoggerManager].
  BMultiLoggerManager(
    super.loggersManager,
  );
}
