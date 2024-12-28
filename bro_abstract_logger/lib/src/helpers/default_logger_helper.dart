import 'package:bro_abstract_logger/src/helpers/default_print_logger.dart';
import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';

class DefaultLoggerHelper extends LoggerHelper {
  static DefaultLoggerHelper? _instance;

  static DefaultLoggerHelper get instance {
    _instance ??= DefaultLoggerHelper._();
    return _instance!;
  }

  DefaultLoggerHelper._()
      : super(
          logger: DefaultPrintLogger.instance,
        );
}
