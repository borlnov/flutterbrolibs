// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:yaml/yaml.dart';

/// Utility class to load a yaml document and convert it to a json object.
///
/// This uses the `yaml` package.
abstract final class YamlUtility {
  /// Load a yaml document from a [content] and convert it to a json object.
  ///
  /// If [logger] is not null, the method will log the errors.
  ///
  /// Returns null if the conversion failed.
  static Map<String, dynamic>? loadYamlDocToJsonObj({
    required String content,
    LoggerHelper? logger,
  }) {
    final yamlDoc = _loadYamlDoc(content: content, logger: logger);
    if (yamlDoc == null) {
      return null;
    }

    final contents = yamlDoc.contents;
    if (contents is! YamlMap) {
      logger?.error('Yaml parsing: the yaml document is not a map');
      return null;
    }

    return _convertMapDocToJson(
      map: contents,
      logger: logger,
    );
  }

  /// Load a yaml document from a [content] and convert it to a json array.
  ///
  /// If [logger] is not null, the method will log the errors.
  ///
  /// Returns null if the conversion failed.
  static List<dynamic>? loadYamlDocToJsonArray({
    required String content,
    LoggerHelper? logger,
  }) {
    final yamlDoc = _loadYamlDoc(content: content, logger: logger);
    if (yamlDoc == null) {
      return null;
    }

    final contents = yamlDoc.contents;
    if (contents is! YamlList) {
      logger?.error('Yaml parsing: the yaml document is not an array');
      return null;
    }

    return _convertListDocToJson(
      list: contents,
      logger: logger,
    );
  }

  /// Load a yaml document from a [content].
  ///
  /// Returns null if the conversion failed.
  static YamlDocument? _loadYamlDoc({
    required String content,
    LoggerHelper? logger,
  }) {
    YamlDocument? yamlDoc;
    try {
      yamlDoc = loadYamlDocument(content);
    } catch (e) {
      logger?.error("Yaml parsing: error while loading yaml document: $e");
    }

    return yamlDoc;
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
    final tmpMap = <String, dynamic>{};
    for (final entry in map.entries) {
      final key = entry.key;
      if (key is! String) {
        logger?.warn('Yaml parsing: unsupported map key type: ${key.runtimeType}');
        continue;
      }

      tmpMap[key] = _convertYamlValueToJsonValue(
        value: entry.value,
        logger: logger,
      );
    }

    return tmpMap;
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
  }) =>
      _convertYamlValueToJsonValue(
        value: scalar.value,
        logger: logger,
      );

  /// Convert a yaml dynamic [value] to a json value.
  ///
  /// If the value is a [YamlNode], it will call [_convertNodeToJsonValue].
  static dynamic _convertYamlValueToJsonValue({
    // We use dynamic here to be able to convert any type of yaml value
    // ignore: avoid_annotating_with_dynamic
    required dynamic value,
    required LoggerHelper? logger,
  }) {
    if (value is YamlNode) {
      return _convertNodeToJsonValue(
        node: value,
        logger: logger,
      );
    }

    if (value is String || value is num || value is bool) {
      return value;
    }

    logger?.error('Yaml parsing: unsupported yaml value type: ${value.runtimeType}');
    return null;
  }
}
