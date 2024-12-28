import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_json_utility/bro_json_utility.dart';
import 'package:bro_types_utility/bro_types_utility.dart';

enum EnvMapFileValueType {
  intEnv(["int", "integer"]),
  doubleEnv(["double", "float", "number"]),
  boolEnv(["bool", "boolean"]),
  stringEnv(["string"]),
  objectEnv(["object", "yaml", "json", "map", "yml"]),
  listEnv(["list", "array"]);

  final List<String> _jsonFormats;

  const EnvMapFileValueType(this._jsonFormats);

  static EnvMapFileValueType? fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in EnvMapFileValueType.values) {
      if (type._jsonFormats.contains(lowerValue)) {
        return type;
      }
    }

    return null;
  }

  dynamic parseValue(
    String value, {
    LoggerHelper? logger,
  }) =>
      switch (this) {
        EnvMapFileValueType.intEnv => int.tryParse(value),
        EnvMapFileValueType.doubleEnv => double.tryParse(value),
        EnvMapFileValueType.boolEnv => BoolUtility.tryParse(value),
        EnvMapFileValueType.stringEnv => value,
        EnvMapFileValueType.objectEnv => YamlUtility.loadYamlDocToJson<Map<String, dynamic>>(
            content: value,
            logger: logger,
          ),
        EnvMapFileValueType.listEnv => YamlUtility.loadYamlDocToJson<List<dynamic>>(
            content: value,
            logger: logger,
          ),
      };
}
