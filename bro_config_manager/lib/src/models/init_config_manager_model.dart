import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:equatable/equatable.dart';

class InitConfigManagerModel extends Equatable {
  final String? configFolderPath;
  final ConfigEnvironmentType? defaultEnvironmentType;
  final Map<String, String> constEnvsValues;

  const InitConfigManagerModel({
    this.configFolderPath,
    this.defaultEnvironmentType,
    LoggerHelper? defaultLoggerHelper,
    this.constEnvsValues = const {},
  });

  @override
  List<Object?> get props => [
        configFolderPath,
        defaultEnvironmentType,
        constEnvsValues,
      ];
}
