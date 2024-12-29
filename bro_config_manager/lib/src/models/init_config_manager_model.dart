// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_logger/bro_abstract_logger.dart';
import 'package:bro_config_manager/src/types/config_environment_type.dart';
import 'package:equatable/equatable.dart';

/// This model contains the configuration to initialize the ConfigManager.
class InitConfigManagerModel extends Equatable {
  /// The path to the folder containing the configuration files.
  ///
  /// If null, the ConfigManager will use the default path.
  final String? configFolderPath;

  /// The default environment type to use.
  ///
  /// If null, the ConfigManager will use the default environment type.
  final ConfigEnvironmentType? defaultEnvironmentType;

  /// The build environments variables to use.
  ///
  /// As explained in the [String.fromEnvironment] the environments variables passed when building
  /// the app (with the `--dart-define` option) are not available at runtime if the key is not
  /// constant. Therefore, the getting of thoses values have to be done in the derived config
  /// manager class and passed to the ConfigManager through the [constEnvsValues] parameter.
  final Map<String, String> constEnvsValues;

  /// The constructor of the class.
  const InitConfigManagerModel({
    this.configFolderPath,
    this.defaultEnvironmentType,
    this.constEnvsValues = const {},
  });

  /// List the properties of the class.
  @override
  List<Object?> get props => [
        configFolderPath,
        defaultEnvironmentType,
        constEnvsValues,
      ];
}
