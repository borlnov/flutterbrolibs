// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// Utility class to manage files in the assets.
abstract final class AssetsUtility {
  /// Load the content of an asset file as a string.
  ///
  /// [assetPath] is the path to the asset file.
  ///
  /// If [cache] is true, the file will be cached. Don't do it if you have your own cache.
  ///
  /// If not null, the [logger] will be used to log the errors.
  static Future<String?> loadAssetString({
    required String assetPath,
    bool cache = true,
    LoggerHelper? logger,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    String? content;
    try {
      content = await rootBundle.loadString(
        assetPath,
        cache: cache,
      );
    } catch (e) {
      logger?.warn("Failed to load the asset: $assetPath; the asset may not exist, error: $e");
    }

    return content;
  }
}
