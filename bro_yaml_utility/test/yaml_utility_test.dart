// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_yaml_utility/bro_yaml_utility.dart';
import 'package:test/test.dart';

/// Test the yaml utility class.
void main() {
  group("Test the yaml object loading", () {
    const yaml1 = '''
      key1: value1
      key2: true
      key3: 1
      key4:
        - value2
        - value3
      key5:
        key6: value1
        key7: value2 # Inline comment

      # This is a comment
      key8: |-
        This is a multiline string
        with multiple lines
    ''';

    const wrongYaml = '''
      key1: value1
        key2: true
    ''';

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
      "key8": "This is a multiline string\nwith multiple lines",
    };

    test("Test the yaml object loading", () {
      final result = YamlUtility.loadYamlDocToJsonObj(content: yaml1);

      expect(result, equals(json1), reason: "The loaded json should be correct");
    });

    test("Test the yaml object loading with wrong yaml", () {
      final result = YamlUtility.loadYamlDocToJsonObj(content: wrongYaml);

      expect(result, isNull, reason: "The loaded json should be null");
    });
  });

  group("Test the yaml array loading", () {
    const yaml1 = '''
      - key1: value1
      - key2: true
      - key3: 1
      - key4:
          - value2
          - value3
      - key5:
          key6: value1
          key7: value2 # Inline comment

      # This is a comment
      - key8: |-
          This is a multiline string
          with multiple lines
    ''';

    const wrongYaml = '''
      - key1
      true
    ''';

    const json1 = <dynamic>[
      {"key1": "value1"},
      {"key2": true},
      {"key3": 1},
      {
        "key4": ["value2", "value3"]
      },
      {
        "key5": {"key6": "value1", "key7": "value2"}
      },
      {"key8": "This is a multiline string\nwith multiple lines"},
    ];

    test("Test the yaml array loading", () {
      final result = YamlUtility.loadYamlDocToJsonArray(content: yaml1);

      expect(result, equals(json1), reason: "The loaded json should be correct");
    });

    test("Test the yaml array loading with wrong yaml", () {
      final result = YamlUtility.loadYamlDocToJsonArray(content: wrongYaml);

      expect(result, isNull, reason: "The loaded json should be null");
    });
  });
}
