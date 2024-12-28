import 'package:bro_abstract_logger/bro_abstract_logger.dart';

abstract final class JsonUtility {
  static Map<String, dynamic> mergeJson(
    Map<String, dynamic> base,
    Map<String, dynamic> toOverrideWith, {
    LoggerHelper? logger,
  }) {
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

  static Map<String, dynamic> mergeNullableJson(
    Map<String, dynamic>? base,
    Map<String, dynamic>? toOverrideWith, {
    LoggerHelper? logger,
  }) {
    if (base == null) {
      return toOverrideWith ?? {};
    }

    if (toOverrideWith == null) {
      return base;
    }

    return mergeJson(
      base,
      toOverrideWith,
      logger: logger,
    );
  }
}
