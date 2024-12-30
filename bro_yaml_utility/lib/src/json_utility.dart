// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';

/// A utility class to manipulate JSON.
abstract final class JsonUtility {
  /// Merge two JSON maps.
  ///
  /// If both map are null, an empty map will be returned.
  ///
  /// If a key is present in both maps, the value from [toOverrideWith] will be used.
  ///
  /// If [logger] is not null, it will be used to log errors.
  static Map<String, dynamic> mergeJson(
    Map<String, dynamic>? base,
    Map<String, dynamic>? toOverrideWith, {
    LoggerHelper? logger,
  }) {
    if (base == null && toOverrideWith == null) {
      return {};
    }

    if (base == null) {
      return Map<String, dynamic>.from(toOverrideWith!);
    }

    if (toOverrideWith == null) {
      return Map<String, dynamic>.from(base);
    }

    final mergedJson = Map<String, dynamic>.from(base);
    for (final entry in toOverrideWith.entries) {
      final key = entry.key;
      if (!mergedJson.containsKey(key)) {
        mergedJson[key] = entry.value;
        continue;
      }

      final baseValue = mergedJson[key];
      final overValue = entry.value;
      if (baseValue is Map<String, dynamic> && overValue is Map<String, dynamic>) {
        mergedJson[key] = mergeJson(
          baseValue,
          overValue,
          logger: logger,
        );
        continue;
      }

      logger?.warn("Json merging: the key $key is already present in the base map, but not with "
          "the same type. The base type: ${baseValue.runtimeType}, the override "
          "type: ${overValue.runtimeType}");
      mergedJson[key] = overValue;
    }

    return mergedJson;
  }
}
