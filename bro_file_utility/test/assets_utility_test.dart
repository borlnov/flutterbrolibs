// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_file_utility/bro_file_utility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const assetsFolderPath = "test/assets";

  group("This test the load asset string function", () {
    test("Load a string file", () async {
      final content = await AssetsUtility.loadAssetString(
        assetPath: "$assetsFolderPath/text_file.txt",
      );

      expect(content, "Macarons glacés\n", reason: "The content of the file is a string.");
    });

    test("Load an empty file", () async {
      final content = await AssetsUtility.loadAssetString(
        assetPath: "$assetsFolderPath/empty_file.txt",
      );

      expect(content, isEmpty, reason: "The content of the file is an empty string.");
    });

    test("Load a binary file", () async {
      final content = await AssetsUtility.loadAssetString(
        assetPath: "$assetsFolderPath/image_file.jpg",
      );

      expect(content, isNull, reason: "The content of the file is null.");
    });
  });
}
