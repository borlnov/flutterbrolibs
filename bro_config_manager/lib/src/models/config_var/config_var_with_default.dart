import 'package:bro_config_manager/src/models/config_var/config_var.dart';
import 'package:flutter/foundation.dart';

class ConfigVarWithDefault<T> extends ConfigVar<T> {
  final T defaultValue;

  ConfigVarWithDefault({
    required super.jsonPath,
    required this.defaultValue,
  });

  ConfigVarWithDefault.jsonPathList({
    required super.jsonPathList,
    required this.defaultValue,
  }) : super.jsonPathList();

  @override
  T load() => tryToLoad() ?? defaultValue;

  @protected
  @override
  T? tryToLoad() => super.tryToLoad();
}
