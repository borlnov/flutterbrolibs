// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_abstract_manager/src/abs_manager_builder.dart';
import 'package:bro_abstract_manager/src/abs_with_life_cycle.dart';
import 'package:bro_config_manager/bro_config_manager.dart';
import 'package:bro_config_manager/src/services/config_companion.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'a_config_manager.dart';

/// The type of the assets configuration to use.
///
/// By default, the name of the enum is used in the path of the configuration file. To override the
/// name, use the [nameOverride] parameter.
enum AssetsConfigType {
  a(ConfigEnvironmentType.development),
  bDev(ConfigEnvironmentType.development, nameOverride: "b"),
  bStaging(ConfigEnvironmentType.staging, nameOverride: "b"),
  bProd(ConfigEnvironmentType.production, nameOverride: "b"),
  cDev(ConfigEnvironmentType.development, nameOverride: "c"),
  cStaging(ConfigEnvironmentType.staging, nameOverride: "c"),
  cProd(ConfigEnvironmentType.production, nameOverride: "c");

  /// The environment type to use.
  final ConfigEnvironmentType envType;

  /// The name override to use in the path of the configuration file.
  final String? nameOverride;

  /// The constructor for the [AssetsConfigType].
  const AssetsConfigType(
    this.envType, {
    this.nameOverride,
  });

  /// The path to the configuration file.
  String get configPath => "test/assets/config_${nameOverride ?? name}";
}

/// The global manager to use for the tests.
class AGlobalManager extends AbsGlobalManager {
  /// The singleton instance of the class.
  static AGlobalManager get instance => AbsGlobalManager.absInstance! as AGlobalManager;

  /// The type of the assets configuration to use.
  final AssetsConfigType _configType;

  /// The constant environment values passed when building the app.
  final Map<String, String> constEnvsValues;

  /// The constructor for the [AGlobalManager].
  AGlobalManager({
    required AssetsConfigType configType,
    this.constEnvsValues = const {},
  }) : _configType = configType;

  /// {@macro abs_global_manager.AbsGlobalManager.registerManagers}
  @override
  void registerManagers(
      void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
          registerManager) {
    registerManager<AConfigManager, AConfigBuilder>(AConfigBuilder(
      configFolderPath: _configType.configPath,
      envType: _configType.envType,
      constEnvsValues: constEnvsValues,
    ));
  }

  /// The method reset the singleton instance of the class and the [ConfigCompanion] singleton.
  /// Then it initializes the global manager and returns the [AConfigManager] instance.
  static Future<AConfigManager> restartTestInstance(
    AssetsConfigType configType, {
    Map<String, String> constEnvsValues = const {},
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    AbsGlobalManager.resetSingleton();
    ConfigCompanion.resetSingleton();

    final globalManager = AbsGlobalManager.getCastedInstance(() => AGlobalManager(
          configType: configType,
          constEnvsValues: constEnvsValues,
        ));

    await globalManager.initLifeCycle();
    return globalManager.getManager<AConfigManager>();
  }
}
