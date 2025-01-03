// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'mock/services/a_global_manager.dart';

/// This is the test for the config manager.
void main() {
  group("This is the test with A config", () {
    test("Test config manager loading", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.a);

      expect(config, isNotNull, reason: "Expect to have a config manager");
    });

    test("Test config var values", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.a);

      expect(config.testAnother.tryToLoad(), 1, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "value", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), true, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "test": 1,
          "test2": 2,
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value1",
          "value2",
          "value3",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false], reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [2, 3, 5], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {"key": "value"},
            {"key2": "value2"},
            {"key3": "value3"},
          ],
          reason: "Test complex array value");
    });
  });

  group("This is the test with B config", () {
    test("Test env yaml files with dev env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.bDev);

      expect(config.testAnother.tryToLoad(), 4, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "value3", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), true, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "test": 1,
          "test2": 2,
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value1",
          "value2",
          "value3",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true], reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [2, 3, 5], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {"key": "value"},
            {"key2": "value2"},
            {"key3": "value3"},
          ],
          reason: "Test complex array value");
      expect(config.testExtraDouble.tryToLoad(), 14.0, reason: "Test extra double value");
    });

    test("Test env yaml files with staging env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.bStaging);

      expect(config.testAnother.tryToLoad(), 4, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "value5", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), true, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "test": 1,
          "test2": 2,
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value1",
          "value2",
          "value3",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true], reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [2, 3, 5], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {"key": "value"},
            {"key2": "value2"},
            {"key3": "value3"},
          ],
          reason: "Test complex array value");
      expect(config.testExtraDouble.tryToLoad(), 14.0, reason: "Test extra double value");
    });

    test("Test env yaml files with prod env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.bProd);

      expect(config.testAnother.tryToLoad(), 4, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "value16", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), true, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "test": 1,
          "test2": 2,
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value1",
          "value2",
          "value3",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true], reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [2, 3, 5], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {"key": "value"},
            {"key2": "value2"},
            {"key3": "value3"},
          ],
          reason: "Test complex array value");
      expect(config.testExtraDouble.tryToLoad(), 14.0, reason: "Test extra double value");
    });
  });

  group("This is the test with C config", () {
    test("Test env yaml files with env variables", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.cDev);

      expect(config.testAnother.tryToLoad(), 400, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "moon", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value1',
          "key2": 'value2',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value45",
          "value67",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4'},
          ],
          reason: "Test complex array value");
    });

    test("Test env yaml files with staging env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.cStaging);

      expect(config.testAnother.tryToLoad(), 500, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "moon", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value1',
          "key2": 'value2',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value45",
          "value67",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4'},
          ],
          reason: "Test complex array value");
    });

    test("Test env yaml files with prod env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.cProd);

      expect(config.testAnother.tryToLoad(), 600, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "moon", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value1',
          "key2": 'value2',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value45",
          "value67",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4'},
          ],
          reason: "Test complex array value");
    });
    test("Test env yaml files with prod env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.bProd);

      expect(config.testAnother.tryToLoad(), 4, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "value16", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), true, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "test": 1,
          "test2": 2,
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value1",
          "value2",
          "value3",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true], reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [2, 3, 5], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {"key": "value"},
            {"key2": "value2"},
            {"key3": "value3"},
          ],
          reason: "Test complex array value");
      expect(config.testExtraDouble.tryToLoad(), 14.0, reason: "Test extra double value");
    });
  });

  group("This is the test with C config", () {
    test("Test env yaml files with env variables", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.cDev);

      expect(config.testAnother.tryToLoad(), 400, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "moon", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value1',
          "key2": 'value2',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value45",
          "value67",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4'},
          ],
          reason: "Test complex array value");
    });

    test("Test env yaml files with staging env", () async {
      final config = await AGlobalManager.restartTestInstance(AssetsConfigType.cStaging);

      expect(config.testAnother.tryToLoad(), 500, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "moon", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value1',
          "key2": 'value2',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value45",
          "value67",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4'},
          ],
          reason: "Test complex array value");
    });

    test("Test env yaml files with const env values", () async {
      final config = await AGlobalManager.restartTestInstance(
        AssetsConfigType.cDev,
        constEnvsValues: {
          "TEST_ANOTHER": "700",
          "TEST_AGAIN_SUB_LEVEL": "jupiter",
          "TEST_AGAIN_KEY2": "false",
          "TEST_AGAIN_COMPLEX": '{"key1": "value3", "key2": "value6"}',
          "TEST_AGAIN_STR_ARRAY": '["value445", "value675"]',
          "TEST_AGAIN_BOOL_ARRAY": '[true, false, true, false, false]',
          "TEST_AGAIN_INT_ARRAY": '[1, 2, 8, 4, 9 , 10]',
          "TEST_AGAIN_COMPLEX_ARRAY": '[{"key1": "value1", "key2": "value2"}, '
              '{"key3": "value3", "key4": "value4", "key5": "value5"}]',
        },
      );

      expect(config.testAnother.tryToLoad(), 700, reason: "Test integer value");
      expect(config.testAgain.tryToLoad(), "jupiter", reason: "Test string value");
      expect(config.testAgainBool.tryToLoad(), false, reason: "Test boolean value");
      expect(
        config.testComplex.tryToLoad(),
        const <String, dynamic>{
          "key1": 'value3',
          "key2": 'value6',
        },
        reason: "Test complex value",
      );

      expect(
        config.testStrArray.tryToLoad(),
        [
          "value445",
          "value675",
        ],
        reason: "Test string array value",
      );
      expect(config.testBoolArray.tryToLoad(), [true, false, true, false, false],
          reason: "Test boolean array value");
      expect(config.testIntArray.tryToLoad(), [1, 2, 8, 4, 9, 10], reason: "Test int array value");
      expect(
          config.testComplexArray.tryToLoad(),
          <Map<String, dynamic>>[
            {'key1': 'value1', 'key2': 'value2'},
            {'key3': 'value3', 'key4': 'value4', 'key5': 'value5'},
          ],
          reason: "Test complex array value");
    });
  });
}
