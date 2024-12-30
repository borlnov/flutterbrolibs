// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_types_utility/bro_types_utility.dart';
import 'package:test/test.dart';

/// Test the bool utility class.
void main() {
  const validTrueValues = <String>[
    "true",
    "True",
    "TRUE",
    "1",
    "yes",
    "Yes",
    "YES",
    "on",
    "On",
    "ON",
  ];

  const validFalseValues = <String>[
    "false",
    "False",
    "FALSE",
    "0",
    "no",
    "No",
    "NO",
    "off",
    "Off",
    "OFF",
  ];
  group("Test try parse bool utility", () {
    test("Test try parse", () {
      for (final value in validTrueValues) {
        expect(BoolUtility.tryParse(value), true, reason: "Try to parse the true value: $value");
      }

      for (final value in validFalseValues) {
        expect(BoolUtility.tryParse(value), false, reason: "Try to parse the false value: $value");
      }

      expect(BoolUtility.tryParse("test"), isNull, reason: "Try to parse an invalid bool value");
    });
  });

  group("Test parse bool utility", () {
    test("Test try parse", () {
      for (final value in validTrueValues) {
        expect(BoolUtility.parse(value), true, reason: "Parse the true value: $value");
      }

      for (final value in validFalseValues) {
        expect(BoolUtility.parse(value), false, reason: "Parse the false value: $value");
      }

      expect(
        () => BoolUtility.parse("test"),
        throwsA(const TypeMatcher<BooleanParseError>()),
        reason: "Try to parse an invalid bool value",
      );
    });
  });
}
