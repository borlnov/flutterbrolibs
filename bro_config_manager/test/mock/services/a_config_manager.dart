// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/bro_config_manager.dart';

import '../mixins/mixin_for_tests_config.dart';

/// A builder for the [AConfigManager] used for the tests.
class AConfigBuilder extends AbsConfigBuilder<AConfigManager> {
  /// The constructor for the [AConfigBuilder].
  AConfigBuilder({
    required String configFolderPath,
    required ConfigEnvironmentType envType,
    required Map<String, String> constEnvsValues,
  }) : super(() => AConfigManager(
              configFolderPath: configFolderPath,
              envType: envType,
              constEnvsValues: constEnvsValues,
            ));

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  Iterable<Type> getDependencies() => [];
}

/// The [AbstractConfigManager] used for the tests.
class AConfigManager extends AbstractConfigManager with MixinForTestsConfig {
  /// The relative folder path to find the configuration files.
  final String configFolderPath;

  /// The environment type to use.
  final ConfigEnvironmentType _envType;

  /// The constant environment values passed when building the app.
  final Map<String, String> constEnvsValues;

  /// The constructor for the [AConfigManager].
  AConfigManager({
    required this.configFolderPath,
    required ConfigEnvironmentType envType,
    required this.constEnvsValues,
  }) : _envType = envType;

  /// {@macro bro_config_manager.AbstractConfigManager.getInitConfigManagerModel}
  @override
  Future<InitConfigManagerModel> getInitConfigManagerModel() async => InitConfigManagerModel(
        configFolderPath: configFolderPath,
        defaultEnvironmentType: _envType,
        constEnvsValues: constEnvsValues,
      );
}
