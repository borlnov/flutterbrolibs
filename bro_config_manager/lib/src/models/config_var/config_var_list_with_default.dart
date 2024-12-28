import 'package:bro_config_manager/src/models/config_var/config_var_with_default.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';

class ConfigVarListWithDefault<T> extends ConfigVarWithDefault<List<T>> {
  ConfigVarListWithDefault({
    required super.jsonPath,
    required super.defaultValue,
  });

  ConfigVarListWithDefault.jsonPathList({
    required super.jsonPathList,
    required super.defaultValue,
  }) : super.jsonPathList();

  @override
  List<T>? tryToLoadProcess() => ConfigCompanion.instance.tryToLoadList<T>(jsonPathList);
}
