import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:bro_global_manager/src/services/abs_global_manager.dart';

mixin MixinManagerWithLogger on AbsWithLifeCycle {
  LoggerHelper? _logger;

  String? get logCategory => null;

  LoggerHelper get logger {
    if (_logger == null) {
      // This is used to create a temporary logger for always have a logger helper to call
      _updateLoggerFromGlobal();
    }

    return _logger!;
  }

  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();

    AbsGlobalManager.absInstance!
        .waitForLoggerManagerInit()
        .then((value) => _updateLoggerFromGlobal());
  }

  void _updateLoggerFromGlobal() {
    _logger = AbsGlobalManager.absInstance!.appLoggerHelper.createSubLogger(
      category: logCategory,
    );
  }
}
