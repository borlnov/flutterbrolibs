// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_platform_utility/bro_platform_utility.dart';

/// An error throwns when the platform is not supported by the manager.
class PlatformNotSupportedByManagerError extends Error {
  /// The current platform of the application
  final PlatformType currentPlatform;

  /// The list of platforms supported by the manager
  final List<PlatformType> supportedPlatforms;

  /// Create a [PlatformNotSupportedByManagerError] with the current platform and the supported
  /// platforms.
  PlatformNotSupportedByManagerError({
    required this.currentPlatform,
    required this.supportedPlatforms,
  });

  /// Get a string representation of the error.
  @override
  String toString() => 'The platform $currentPlatform is not supported by the manager. '
      'The supported platforms by the manager are $supportedPlatforms.';
}
