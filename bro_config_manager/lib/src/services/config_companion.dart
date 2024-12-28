import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_list_utility/bro_list_utility.dart';

class ConfigCompanion {
  static ConfigCompanion? _instance;

  static ConfigCompanion get instance => _instance!;

  static void create({
    required Map<String, dynamic> json,
    required LoggerHelper Function() getLoggerHelper,
  }) {
    if (_instance != null) {
      // Nothing to do
      return;
    }

    _instance = ConfigCompanion(
      json: json,
      getLoggerHelper: getLoggerHelper,
    );
  }

  final Map<String, dynamic> _json;
  final LoggerHelper Function() getLoggerHelper;

  const ConfigCompanion({
    required Map<String, dynamic> json,
    required this.getLoggerHelper,
  }) : _json = json;

  T? tryToLoad<T>(List<String> jsonPath) {
    final value = _getJsonValue(jsonPath);
    if (value == null) {
      return null;
    }

    if (value is! T) {
      getLoggerHelper().warn("The json value: $value, isn't a ${T.runtimeType}, we can't load "
          "config from it");
      return null;
    }

    return value;
  }

  List<T>? tryToLoadList<T>(List<String> jsonPath) {
    final values = _getJsonValue(jsonPath);
    if (values == null) {
      return null;
    }

    if (values is! List<dynamic>) {
      getLoggerHelper().warn("The json value: $values, isn't a list, we can't load config from it");
      return null;
    }

    return ListUtility.tryToCastFromDynamic(values);
  }

  dynamic _getJsonValue(List<String> jsonPath) {
    var tmpJson = _json;
    dynamic tmpValue;

    for (var idx = 0; idx < jsonPath.length; ++idx) {
      tmpValue = tmpJson[jsonPath[idx]];
      if (tmpValue == null) {
        break;
      }

      if (idx == (jsonPath.length - 1)) {
        // Nothing more to do here
      } else if (tmpValue is! Map<String, dynamic>) {
        // We can't go further; therefore the value is not accessible
        tmpValue = null;
        break;
      } else {
        tmpJson = tmpValue;
      }
    }

    return tmpValue;
  }
}
