// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';

/// Helper to create a sub-logger.
///
/// The class uses the parent logger to log messages.
class SubLoggerHelper extends LoggerHelper {
  /// The parent logger.
  final LoggerHelper _parent;

  /// The external logger to use to log messages.
  @override
  MixinExternalLogger get logger => _parent.logger;

  /// The constructor for the sub-logger.
  SubLoggerHelper({
    required LoggerHelper parent,
    required String? category,
    super.minLevel,
  })  : _parent = parent,
        super.subLogger(
          categories: [
            ...parent.categories,
            if (category != null) category,
          ],
        );

  /// {@macro bro_abstract_logger.LoggerHelper.updateLogger}
  @override
  void updateLogger(MixinExternalLogger logger) {
    _parent.updateLogger(logger);
  }
}
