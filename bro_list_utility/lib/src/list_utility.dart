import 'package:bro_abstract_logger/bro_abstract_logger.dart';

abstract final class ListUtility {
  static List<T>? tryToCastFromDynamic<T>(
    List<dynamic> values, {
    LoggerHelper? logger,
    bool displayLog = true,
  }) {
    final tmpValues = <T>[];
    for (final value in values) {
      if (value is! T) {
        if (displayLog && logger != null) {
          logger.warn("The given list: $values, contains elements which are not of "
              "${T.runtimeType} type");
        }
        return null;
      }
      tmpValues.add(value);
    }

    return tmpValues;
  }
}
