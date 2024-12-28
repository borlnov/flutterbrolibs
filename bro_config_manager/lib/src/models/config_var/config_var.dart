import 'package:bro_config_manager/src/services/config_companion.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ConfigVar<T> {
  static const String jsonPathSeparator = ".";

  final List<String> _jsonPathList;

  List<String> get jsonPathList => _jsonPathList;

  bool _isLoaded;

  T? _loadedValue;

  ConfigVar({
    required String jsonPath,
  })  : _jsonPathList = jsonPath.split(jsonPathSeparator),
        _isLoaded = false;

  ConfigVar.jsonPathList({
    required List<String> jsonPathList,
  })  : _jsonPathList = jsonPathList,
        _isLoaded = false;

  T load() => tryToLoad()!;

  T? tryToLoad() {
    if (!_isLoaded) {
      _loadedValue = tryToLoadProcess();
      _isLoaded = true;
    }

    return _loadedValue;
  }

  @protected
  T? tryToLoadProcess() => ConfigCompanion.instance.tryToLoad(_jsonPathList);
}
