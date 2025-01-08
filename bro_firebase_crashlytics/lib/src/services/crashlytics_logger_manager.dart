// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/bro_config_manager.dart';
import 'package:bro_firebase_crashlytics/src/helpers/crashlytics_logger.dart';
import 'package:bro_firebase_crashlytics/src/mixins/mixin_crashlytics_configs.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// This is the builder to create the [CrashlyticsLoggerManager].
class CrashlyticsBuilder<C extends MixinCrashlyticsConfigs>
    extends AbsLoggerBuilder<CrashlyticsLoggerManager> {
  /// Create the [CrashlyticsBuilder].
  const CrashlyticsBuilder() : super();

  /// {@macro bro_abstract_manager.AbsManagerBuilder.create}
  @override
  CrashlyticsLoggerManager create() => CrashlyticsLoggerManager(
        configManagerGetter: globalGetManager<C>,
        isPlatformSupported: isPlatformSupported(),
      );

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getSupportedPlatforms}
  @override
  List<PlatformType> getSupportedPlatforms() => const [PlatformType.android, PlatformType.iOS];

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getWrongPlatformBehavior}
  @override
  WrongPlatformBehavior getWrongPlatformBehavior() => WrongPlatformBehavior.continueProcess;

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [C];
}

/// This is the logger manager used to log with Firebase Crashlytics.
///
/// This manager is used to log with Firebase Crashlytics. It will only be used if the platform is
/// supported and if the [_crashlyticsEnabled] is true.
///
/// To use it with your favorite logger manager, you should use both with the
/// [AbstractMultiLoggerManager].
///
/// To use this manager, you have to add the [MixinCrashlyticsConfigs] to your implementation of
/// the [AbstractConfigManager].
class CrashlyticsLoggerManager extends AbstractLoggerManager {
  /// This is the getter to get the [MixinCrashlyticsConfigs].
  final MixinCrashlyticsConfigs Function() configManagerGetter;

  /// This is the flag to know if the current platform is supported, or not. If not, the manager is
  /// initiazed but crashlytics is disabled (like if [_crashlyticsEnabled] is equal to false).
  final bool isPlatformSupported;

  /// This is the flag to know if the crashlytics is enabled or not.
  late final bool _crashlyticsEnabled;

  /// This is used to know if the automatic sending of the crashlytics is enabled or not.
  ///
  /// If true, the crashlytics will be sent automatically at the application next start, otherwise,
  /// you have to call the [forceReportsSending] method to send the crashlytics manually.
  late final bool _autoCrashlyticsSent;

  /// This is the Firebase Crashlytics instance.
  late final FirebaseCrashlytics _crashlytics;

  /// Class constructor
  CrashlyticsLoggerManager({
    required this.configManagerGetter,
    required this.isPlatformSupported,
  }) : super();

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    final configManager = configManagerGetter();

    _crashlytics = FirebaseCrashlytics.instance;
    if (isPlatformSupported) {
      _crashlyticsEnabled = configManager.crashlyticsEnabled.load();
      _autoCrashlyticsSent = _crashlytics.isCrashlyticsCollectionEnabled;
    } else {
      _crashlyticsEnabled = false;
      _autoCrashlyticsSent = false;
    }
    await super.initLifeCycle();
  }

  /// This method updates the auto crashlytics sent flag.
  ///
  /// If true, the crashlytics will be sent automatically at the application next start, otherwise,
  /// you have to call the [forceReportsSending] method to send the crashlytics manually.
  ///
  /// If [_crashlyticsEnabled] is false, no logs will be sent to Firebase Crashlytics.
  ///
  /// If the current platform is not supported, the method does nothing.
  Future<void> updateAutoCrashlyticsSent({
    required bool value,
  }) async {
    if (!isPlatformSupported || _autoCrashlyticsSent == value) {
      return;
    }

    await _crashlytics.setCrashlyticsCollectionEnabled(value);
    _autoCrashlyticsSent = value;
  }

  /// This method forces the sending of the crashlytics.
  ///
  /// This method is only used if the [_autoCrashlyticsSent] is false. If it's true, the crashlytics
  /// will be sent automatically at the application next start.
  ///
  /// If [_crashlyticsEnabled] is false, but there are logs saved in crashlytics, they will be sent
  /// to Firebase Crashlytics.
  ///
  /// If the current platform is not supported, the method does nothing.
  Future<void> forceReportsSending() async {
    if (!isPlatformSupported || _autoCrashlyticsSent) {
      // This not relevant to force reports sending if auto sent is enabled
      // Or if the platform is not supported
      return;
    }

    final isThereUnsentReport = await _crashlytics.checkForUnsentReports();
    if (!isThereUnsentReport) {
      // Nothing to send
      return;
    }

    return FirebaseCrashlytics.instance.sendUnsentReports();
  }

  /// This method sets an user identifier.
  ///
  /// BE CAREFUL: this will identify the user in the Firebase Crashlytics console; therefore, you
  /// have to get the user permission to do that.
  ///
  /// If [_crashlyticsEnabled] is false or if the current platform is not supported, the method
  /// does nothing.
  Future<void> setUserIdentifier(String identifier) async {
    if (!isPlatformSupported || !_crashlyticsEnabled) {
      return;
    }

    return _crashlytics.setUserIdentifier(identifier);
  }

  /// {@macro bro_abstract_logger.AbstractLoggerManager.getExternalLogger}
  @override
  Future<MixinExternalLogger> getExternalLogger() async {
    final configManager = configManagerGetter();

    return CrashlyticsLogger(
      crashlyticsEnabled: _crashlyticsEnabled,
      includeLastLogsNb: configManager.includeLastLogsNb.tryToLoad(),
      includeLastLogsMinLevel: configManager.includeLastLogsMinLevel.load(),
    );
  }
}
