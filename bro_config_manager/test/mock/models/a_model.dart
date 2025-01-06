// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:equatable/equatable.dart';

/// A simple model with a name and an age to be parsed as config
class AModel extends Equatable {
  /// The key for the name in the json
  static const nameKey = 'name';

  /// The key for the age in the json
  static const ageKey = 'age';

  /// The name of the model
  final String name;

  /// The age of the model
  final int age;

  /// Creates a new AModel
  const AModel({
    required this.name,
    required this.age,
  });

  /// Creates a new AModel from a json
  // The type is dynamic because we can parse the model from a json object or array
  // ignore: avoid_annotating_with_dynamic
  static AModel? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return null;
    }

    final name = json[nameKey];
    final age = json[ageKey];

    if (name == null || age == null || name is! String || age is! int) {
      return null;
    }

    return AModel(
      name: name,
      age: age,
    );
  }

  /// Model properties
  @override
  List<Object?> get props => [name, age];
}
