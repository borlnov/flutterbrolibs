// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:yaml/yaml.dart';

/// Utility class to load a yaml document and convert it to a json object.
///
/// This uses the `yaml` package.
abstract final class YamlUtility {
  /// Load a yaml document from a [content] and convert it to a json object or json array.
  ///
  /// If the [T] type is not a `Map<String, dynamic>` or a `List<dynamic>`, the method will return
  /// null. The primary type of the json document must match the [T] type.
  ///
  /// If [logger] is not null, the method will log the errors.
  ///
  /// Returns null if the conversion failed.
  static T? loadYamlDocToJson<T>({
    required String content,
    LoggerHelper? logger,
  }) {
    if (T is! Map<String, dynamic> && T is! List<dynamic>) {
      logger?.error('Yaml parsing: unsupported type: ${T.runtimeType}');
      return null;
    }

    YamlDocument yamlDoc;
    try {
      yamlDoc = loadYamlDocument(content);
    } catch (e) {
      logger?.error("Yaml parsing: error while loading yaml document: $e");
      return null;
    }

    final contents = yamlDoc.contents;
    if (T is Map<String, dynamic> && contents is YamlMap) {
      return _convertMapDocToJson(
        map: contents,
        logger: logger,
      ) as T;
    }

    if (T is List<dynamic> && contents is YamlList) {
      return _convertListDocToJson(
        list: contents,
        logger: logger,
      ) as T;
    }

    logger?.error("Yaml parsing: type mismatch: ${contents.runtimeType} vs ${T.runtimeType}");
    return null;
  }

  /// Convert the [YamlMap] value of a [YamlDocument] to a json object.
  static Map<String, dynamic> _convertMapDocToJson({
    required YamlMap map,
    required LoggerHelper? logger,
  }) =>
      _convertNodeToJsonValue(
        node: map,
        logger: logger,
      ) as Map<String, dynamic>;

  /// Convert the [YamlList] value of a [YamlDocument] to a json array.
  static List<dynamic> _convertListDocToJson({
    required YamlList list,
    required LoggerHelper? logger,
  }) =>
      _convertNodeToJsonValue(
        node: list,
        logger: logger,
      ) as List<dynamic>;

  /// Convert a [YamlNode] to the right json element.
  static dynamic _convertNodeToJsonValue({
    required YamlNode node,
    required LoggerHelper? logger,
  }) {
    if (node is YamlMap) {
      return _convertYamlMapToJsonValue(map: node, logger: logger);
    }

    if (node is YamlList) {
      return _convertYamlListToJsonValue(list: node, logger: logger);
    }

    if (node is YamlScalar) {
      return _convertYamlScalarToJsonValue(scalar: node, logger: logger);
    }

    throw UnsupportedError('Yaml parsing: unsupported node type: ${node.runtimeType}');
  }

  /// Convert a [YamlMap] to a json object
  static dynamic _convertYamlMapToJsonValue({
    required YamlMap map,
    required LoggerHelper? logger,
  }) {
    final map = <String, dynamic>{};
    for (final entry in map.entries) {
      map[entry.key] = _convertNodeToJsonValue(
        node: entry.value as YamlNode,
        logger: logger,
      );
    }

    return map;
  }

  /// Convert a [YamlList] to a json array.
  static dynamic _convertYamlListToJsonValue({
    required YamlList list,
    required LoggerHelper? logger,
  }) {
    final tmpList = <dynamic>[];
    for (final value in list.nodes) {
      tmpList.add(_convertNodeToJsonValue(
        node: value,
        logger: logger,
      ));
    }

    return tmpList;
  }

  /// Convert a [YamlScalar] to a json value.
  static dynamic _convertYamlScalarToJsonValue({
    required YamlScalar scalar,
    required LoggerHelper? logger,
  }) {
    final value = scalar.value;
    if (value is String || value is num || value is bool) {
      return value;
    }

    logger?.error('Yaml parsing: unsupported scalar type: ${value.runtimeType}');
    return null;
  }
}
