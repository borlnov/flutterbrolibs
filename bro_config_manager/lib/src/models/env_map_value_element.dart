import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/models/env_map_file_element.dart';

class EnvMapValueElement extends EnvMapFileElement {
  final dynamic value;

  const EnvMapValueElement._({
    required super.jsonPath,
    required super.envKey,
    required super.valueType,
    required this.value,
  });

  static EnvMapValueElement? fromEnvMapElement({
    required EnvMapFileElement envMapElement,
    required String value,
    LoggerHelper? logger,
  }) {
    final parsedValue = envMapElement.valueType.parseValue(value);
    if (parsedValue == null) {
      logger?.warn("EnvMapValueElement: failed to parse the value: $value for the element: "
          "$envMapElement, it has not the right type: ${envMapElement.valueType}");
      return null;
    }

    return EnvMapValueElement._(
      jsonPath: envMapElement.jsonPath,
      envKey: envMapElement.envKey,
      valueType: envMapElement.valueType,
      value: parsedValue,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        value,
      ];
}
