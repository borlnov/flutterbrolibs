import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_abstract_manager/bro_abstract_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class AbsMultiLoggerBuilder<L extends AbstractMultiLoggerManager>
    extends AbsManagerBuilder<L> {
  final List<AbsLoggerBuilder> _loggersBuilders;

  AbsMultiLoggerBuilder({
    required L Function(List<AbstractLoggerManager> loggerManager) mainManagerFactory,
    required List<AbsLoggerBuilder> loggersBuilders,
  })  : _loggersBuilders = loggersBuilders,
        super(() => _multiFactory(
              mainManagerFactory: mainManagerFactory,
              loggersBuilders: loggersBuilders,
            ));

  static L _multiFactory<L extends AbstractMultiLoggerManager>({
    required L Function(List<AbstractLoggerManager> loggerManager) mainManagerFactory,
    required List<AbsLoggerBuilder> loggersBuilders,
  }) {
    final managers = <AbstractLoggerManager>[];
    for (final builder in loggersBuilders) {
      managers.add(builder.managerFactory());
    }

    return mainManagerFactory(managers);
  }

  @override
  @mustCallSuper
  Iterable<Type> getDependencies() =>
      _loggersBuilders.expand((element) => element.getDependencies());
}

abstract class AbstractMultiLoggerManager extends AbstractLoggerManager {
  final List<AbstractLoggerManager> _loggersManager;

  AbstractMultiLoggerManager(List<AbstractLoggerManager> loggersManager)
      : _loggersManager = loggersManager;

  @override
  Future<void> initLifeCycle() async {
    await Future.wait(_loggersManager.map((manager) => manager.initLifeCycle()));

    return super.initLifeCycle();
  }

  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    await Future.wait(_loggersManager.map((manager) => manager.initAfterViewBuilt(context)));

    return super.initAfterViewBuilt(context);
  }

  @override
  Future<void> disposeLifeCycle() async {
    await Future.wait(_loggersManager.map((manager) => manager.disposeLifeCycle()));

    return super.disposeLifeCycle();
  }
}
