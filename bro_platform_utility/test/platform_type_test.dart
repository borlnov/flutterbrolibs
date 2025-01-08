// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_platform_utility/bro_platform_utility.dart';
import 'package:flutter_test/flutter_test.dart';

/// This is the test for the [PlatformType] class.
void main() {
  group("Test the `isCurrentSupported` method", () {
    test("Test the results of the method", () {
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.android,
          supportedPlatforms: [PlatformType.android],
        ),
        true,
        reason: "test if the current platform is supported, with one element in the list",
      );
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.iOS,
          supportedPlatforms: [PlatformType.android, PlatformType.iOS],
        ),
        true,
        reason: "the current platform is supported, with multiple elements in the list",
      );
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.web,
          supportedPlatforms: [],
        ),
        false,
        reason: "the current platform isn't supported, with an empty list",
      );
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.web,
          supportedPlatforms: [PlatformType.windows, PlatformType.linux],
        ),
        false,
        reason: "the current platform isn't supported",
      );
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.windows,
          supportedPlatforms: [PlatformType.irrelevant],
        ),
        true,
        reason: "the current platform is supported, with irrelevant",
      );
      expect(
        PlatformType.isCurrentSupported(
          currentPlatform: PlatformType.irrelevant,
          supportedPlatforms: [PlatformType.windows, PlatformType.irrelevant, PlatformType.web],
        ),
        true,
        reason: "the current platform is supported, with irrelevant surrounded by other platforms",
      );
    });
    test("Test the platform guessing", () {
      expect(
        PlatformType.isCurrentSupported(
          supportedPlatforms: [PlatformType.guessCurrentPlatform()],
        ),
        true,
        reason: "the current platform is supported, with the guessed platform",
      );
    });
  });
}
