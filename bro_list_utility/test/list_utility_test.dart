// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_list_utility/bro_list_utility.dart';
import 'package:test/test.dart';

/// This tests the list utility methods.
void main() {
  group("Try to cast from dynamic array", () {
    const dynamicIntArray = <dynamic>[
      1,
      2,
      3,
      4,
      5,
    ];

    const dynamicStrArray = <dynamic>[
      "1",
      "2",
      "3",
      "4",
    ];

    const dynamicBoolArray = <dynamic>[
      true,
      false,
      true,
      true,
    ];

    const dynamicComplexArray = <dynamic>[
      {"key1": "value1"},
      {"key2": "value2"},
      {"key3": "value3"},
      {"key4": "value4"},
      {"key5": "value5"},
    ];

    const dynamicMixedArray = <dynamic>[
      1,
      "2",
      true,
      {"key1": "value1"},
      5,
    ];

    test("Test to cast from integer dynamic array", () {
      expect(
        ListUtility.tryToCastFromDynamic<int>(dynamicIntArray),
        equals(dynamicIntArray.cast<int>()),
        reason: "Try to cast from integer dynamic array",
      );
      expect(
        ListUtility.tryToCastFromDynamic<String>(dynamicIntArray),
        isNull,
        reason: "Try to cast an integer dynamic array to string",
      );
    });

    test("Test to cast from string dynamic array", () {
      expect(
        ListUtility.tryToCastFromDynamic<String>(dynamicStrArray),
        equals(dynamicStrArray.cast<String>()),
        reason: "Try to cast from integer dynamic array",
      );
      expect(
        ListUtility.tryToCastFromDynamic<bool>(dynamicStrArray),
        isNull,
        reason: "Try to cast a string dynamic array to bool",
      );
    });

    test("Test to cast from bool dynamic array", () {
      expect(
        ListUtility.tryToCastFromDynamic<bool>(dynamicBoolArray),
        equals(dynamicBoolArray.cast<bool>()),
        reason: "Try to cast from boolean dynamic array",
      );
      expect(
        ListUtility.tryToCastFromDynamic<int>(dynamicBoolArray),
        isNull,
        reason: "Try to cast a bool dynamic array to int",
      );
    });

    test("Test to cast from complex dynamic array", () {
      expect(
        ListUtility.tryToCastFromDynamic<Map<String, String>>(dynamicComplexArray),
        equals(dynamicComplexArray.cast<Map<String, String>>()),
        reason: "Try to cast from complex dynamic array",
      );
      expect(
        ListUtility.tryToCastFromDynamic<Map<String, int>>(dynamicComplexArray),
        isNull,
        reason: "Try to cast a complex dynamic array to int",
      );
    });

    test("Test to cast from mixed dynamic array", () {
      expect(
        ListUtility.tryToCastFromDynamic<dynamic>(dynamicMixedArray),
        dynamicMixedArray,
        reason: "Try to cast from mixed dynamic array",
      );
      expect(
        ListUtility.tryToCastFromDynamic<int>(dynamicMixedArray),
        isNull,
        reason: "Try to cast a mixed dynamic array to int",
      );
    });
  });
}
