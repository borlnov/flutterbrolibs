import 'package:bro_config_manager/src/models/config_var/config_var.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';

class ConfigVarList<T> extends ConfigVar<List<T>> {
  ConfigVarList({
    required super.jsonPath,
  });

  ConfigVarList.jsonPathList({
    required super.jsonPathList,
  }) : super.jsonPathList();

  @override
  List<T>? tryToLoadProcess() => ConfigCompanion.instance.tryToLoadList<T>(jsonPathList);
}
