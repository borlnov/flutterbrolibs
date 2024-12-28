import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:yaml/yaml.dart';

abstract final class YamlUtility {
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
      return _convertMapToJson(
        map: contents,
        logger: logger,
      ) as T;
    }

    if (T is List<dynamic> && contents is YamlList) {
      return _convertListToJson(
        list: contents,
        logger: logger,
      ) as T;
    }

    logger?.error("Yaml parsing: type mismatch: ${contents.runtimeType} vs ${T.runtimeType}");
    return null;
  }

  static Map<String, dynamic> _convertMapToJson({
    required YamlMap map,
    required LoggerHelper? logger,
  }) =>
      _convertNodeToJsonValue(
        node: map,
        logger: logger,
      ) as Map<String, dynamic>;

  static List<dynamic> _convertListToJson({
    required YamlList list,
    required LoggerHelper? logger,
  }) =>
      _convertNodeToJsonValue(
        node: list,
        logger: logger,
      ) as List<dynamic>;

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
