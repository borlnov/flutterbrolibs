// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/bro_config_manager.dart';

import '../models/a_model.dart';

/// Contains all the [ConfigVar] and [ConfigVarList] for the tests.
mixin MixinForTestsConfig on AbstractConfigManager {
  final testAnother = SimpleConfigVar<int>(jsonPath: "test.another");

  final testAgain = SimpleConfigVar<String>(jsonPath: "testAgain.subLevel.key");

  final testAgainBool = SimpleConfigVar<bool>(jsonPath: "testAgain.key2");

  final testComplex = SimpleConfigVar<Map<String, dynamic>>(jsonPath: "testAgain.complex");

  final testStrArray = ConfigVarList<String>(jsonPath: "testAgain.strArray");

  final testBoolArray = ConfigVarList<bool>(jsonPath: "testAgain.boolArray");

  final testIntArray = ConfigVarList<int>(jsonPath: "testAgain.intArray");

  final testComplexArray = ConfigVarList<Map<String, dynamic>>(jsonPath: "testAgain.complexArray");

  final testExtraDouble = SimpleConfigVar<double>(jsonPath: "test.extraDouble");

  final testDefaultValue = SimpleConfigVar<String>(
    jsonPath: "test.defautValue",
    defaultValue: "default",
  );

  final testObjectConverter = ConfigVar(
    jsonPath: "testConverter.modelA",
    converter: AModel.fromJson,
  );

  final testArrayConverter = ConfigVarList(
    jsonPath: "testConverter.modelAArray",
    elemConverter: AModel.fromJson,
  );
}
