// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:bro_platform_utility/src/errors/cant_guess_platform_error.dart';
import 'package:flutter/foundation.dart';

/// The type of platform the app is running on.
enum PlatformType {
  /// This means that the platform type is not relevant for the current context.
  irrelevant,

  /// The app is running on an Android device.
  android,

  /// The app is running on an iOS device.
  iOS,

  /// The app is running on a web browser.
  web,

  /// The app is running on a macOS device.
  macOS,

  /// The app is running on a Windows device.
  windows,

  /// The app is running on a Linux device.
  linux,

  /// The app is running on a Fuchsia device.
  fuchsia;

  /// Check if the current platform is supported by the manager.
  ///
  /// If [currentPlatform] is null, the current platform will be guessed using
  /// [guessCurrentPlatform].
  static bool isCurrentSupported({
    PlatformType? currentPlatform,
    required List<PlatformType> supportedPlatforms,
  }) {
    final tmpCurrentPlatform = currentPlatform ?? guessCurrentPlatform();
    if (supportedPlatforms.contains(irrelevant)) {
      return true;
    }
    return supportedPlatforms.contains(tmpCurrentPlatform);
  }

  /// Guess the current platform of the app device.
  static PlatformType guessCurrentPlatform() {
    PlatformType? platformType;
    if (Platform.isAndroid) {
      platformType = android;
    } else if (Platform.isIOS) {
      platformType = iOS;
    } else if (Platform.isMacOS) {
      platformType = macOS;
    } else if (Platform.isWindows) {
      platformType = windows;
    } else if (Platform.isLinux) {
      platformType = linux;
    } else if (Platform.isFuchsia) {
      platformType = fuchsia;
    } else if (kIsWeb) {
      platformType = web;
    } else {
      throw CantGuessPlatformError();
    }

    return platformType;
  }
}
