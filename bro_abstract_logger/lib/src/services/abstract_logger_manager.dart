import 'package:bro_abstract_logger/src/helpers/logger_helper.dart';
import 'package:bro_abstract_logger/src/mixins/mixin_external_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/foundation.dart';

abstract class AbsLoggerBuilder<L extends AbstractLoggerManager> extends AbsManagerBuilder<L> {
  AbsLoggerBuilder(super.managerFactory);
}

abstract class AbstractLoggerManager extends AbsWithLifeCycle {
  late final MixinExternalLogger _externalLogger;
  late final LoggerHelper loggerHelper;

  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    _externalLogger = await getExternalLogger();
    loggerHelper = LoggerHelper(logger: _externalLogger);
  }

  @protected
  Future<MixinExternalLogger> getExternalLogger();
}
