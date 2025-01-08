// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/foundation.dart';

/// This is the type of the Platform error handler.
typedef PlatformErrorHandler = bool Function(Object exception, StackTrace stackTrace);

/// This is an abstract builder for logger managers.
abstract class AbsLoggerBuilder<L extends AbstractLoggerManager> extends AbsManagerBuilder<L> {
  /// Class constructor.
  const AbsLoggerBuilder();
}

/// This is the abstract class for logger managers.
///
/// It provides a logger helper to manage the logs. The [loggerHelper] is always usable even if
/// [initLifeCycle] has not be called yet: at class start, it's created with the default print
/// logger. The [loggerHelper] is updated when calling the [getExternalLogger] method.
abstract class AbstractLoggerManager extends AbsWithLifeCycle {
  /// The external logger to use with the logger manager.
  late final MixinExternalLogger _externalLogger;

  /// The default Flutter error handler.
  FlutterExceptionHandler? _defaultFlutterErrorHandler;

  /// The default platform error handler.
  PlatformErrorHandler? _defaultPlatformErrorHandler;

  /// The logger helper to use with the logger manager.
  final LoggerHelper loggerHelper;

  /// If true, the manager will register a handler for the Flutter and platform non-managed errors.
  ///
  /// {@template bro_abstract_logger.AbstractLoggerManager.registerFlutterNonManagedErrorsAttention}
  /// Beware, only one logger manager should register the errors. If multiple managers register the
  /// errors, the last one will be the one that will manage the errors.
  /// {@endtemplate}
  final bool registerFlutterNonManagedErrors;

  /// Class constructor.
  AbstractLoggerManager({
    bool printLogsByDefault = true,
    this.registerFlutterNonManagedErrors = false,
  }) : loggerHelper = LoggerHelper.initWithDefaultLogger(
          printLogs: printLogsByDefault,
        );

  /// Class constructor to create the manager from a logger helper.
  @protected
  AbstractLoggerManager.fromLoggerHelper({
    required this.loggerHelper,
    this.registerFlutterNonManagedErrors = false,
  });

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    _externalLogger = await getExternalLogger();
    loggerHelper.updateLogger(_externalLogger);

    registerFlutterNonManagedErrorsProcess();
  }

  /// This method registers the Flutter and platform non-managed errors if the
  /// [registerFlutterNonManagedErrors] is true.
  @protected
  void registerFlutterNonManagedErrorsProcess() {
    if (registerFlutterNonManagedErrors) {
      _defaultFlutterErrorHandler = FlutterError.onError;
      _defaultPlatformErrorHandler = PlatformDispatcher.instance.onError;
      FlutterError.onError = _manageFlutterError;
      PlatformDispatcher.instance.onError = _managePlatformError;
    }
  }

  /// This method is called when a Flutter error is thrown.
  ///
  /// It logs a fatal error with the exception and the stack trace.
  void _manageFlutterError(FlutterErrorDetails details) => loggerHelper.logErrorWithException(
        details.exception,
        stackTrace: details.stack,
        isFatal: true,
      );

  /// This method is called when a platform error is thrown.
  ///
  /// It logs a fatal error with the error and the stack trace.
  bool _managePlatformError(Object error, StackTrace stackTrace) {
    _externalLogger.logErrorWithException(
      error,
      stackTrace: stackTrace,
      isFatal: true,
    );

    // We managed the error so we return true to prevent the error to be managed by the default
    // error handler.
    return true;
  }

  /// {@template bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  /// This method returns the external logger to use with the logger manager.
  ///
  /// Once the object is returned by this method, its life will be managed by this logger manager.
  /// {@endtemplate}
  @protected
  Future<MixinExternalLogger> getExternalLogger();

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.disposeLifeCycle}
  @override
  Future<void> disposeLifeCycle() async {
    if (registerFlutterNonManagedErrors) {
      // We restore the default error handlers.
      FlutterError.onError = _defaultFlutterErrorHandler;
      PlatformDispatcher.instance.onError = _defaultPlatformErrorHandler;
    }
    await _externalLogger.dispose();
    await super.disposeLifeCycle();
  }
}
