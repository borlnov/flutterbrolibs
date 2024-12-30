// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_yaml_utility/bro_yaml_utility.dart';
import 'package:test/test.dart';

/// Test the json utility class.
void main() {
  group("Test the json merge", () {
    const json1 = <String, dynamic>{
      "key1": "value1",
      "key2": true,
      "key3": 1,
      "key4": [
        "value2",
        "value3",
      ],
      "key5": {
        "key6": "value1",
        "key7": "value2",
      },
    };

    const json2 = <String, dynamic>{
      "key1": "value3",
      "key2": false,
      "key4": [
        "value1",
      ],
      "key5": {
        "key6": {
          "key8": "value1",
          "key9": "value2",
        },
      },
    };

    const mergedJson = <String, dynamic>{
      "key1": "value3",
      "key2": false,
      "key3": 1,
      "key4": [
        "value1",
      ],
      "key5": {
        "key6": {
          "key8": "value1",
          "key9": "value2",
        },
        "key7": "value2",
      },
    };

    test("Test the json merge", () {
      final result = JsonUtility.mergeJson(json1, json2);

      expect(result, equals(mergedJson), reason: "The merged json should be correct");
    });

    test("Test incorrect json merge", () {
      final result = JsonUtility.mergeJson(json1, json2);
      result["key5"] = {
        "key6": {
          "key8": "value5",
        },
        "key7": "value2",
      };

      expect(result, isNot(equals(mergedJson)), reason: "The merged json should be inccorrect");
    });

    test("Test the json merge with null base", () {
      final result = JsonUtility.mergeJson(null, json2);

      expect(result, equals(json2), reason: "The merged json should be correct");
    });

    test("Test the json merge with null override json", () {
      final result = JsonUtility.mergeJson(json1, null);

      expect(result, equals(json1), reason: "The merged json should be correct");
    });
  });
}
