// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_config_manager/bro_config_manager.dart';

/// Contains all the [ConfigVar] and [ConfigVarList] for the tests.
mixin MixinForTestsConfig on AbstractConfigManager {
  final testAnother = ConfigVar<int>(jsonPath: "test.another");

  final testAgain = ConfigVar<String>(jsonPath: "testAgain.subLevel.key");

  final testAgainBool = ConfigVar<bool>(jsonPath: "testAgain.key2");

  final testComplex = ConfigVar<Map<String, dynamic>>(jsonPath: "testAgain.complex");

  final testStrArray = ConfigVarList<String>(jsonPath: "testAgain.strArray");

  final testBoolArray = ConfigVarList<bool>(jsonPath: "testAgain.boolArray");

  final testIntArray = ConfigVarList<int>(jsonPath: "testAgain.intArray");

  final testComplexArray = ConfigVarList<Map<String, dynamic>>(jsonPath: "testAgain.complexArray");

  final testExtraDouble = ConfigVar<double>(jsonPath: "test.extraDouble");
}
