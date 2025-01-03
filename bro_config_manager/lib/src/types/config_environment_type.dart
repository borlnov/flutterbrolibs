// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// This is the environment type.
enum ConfigEnvironmentType {
  /// The development environment.
  development(aliases: ["dev", "develop", "development"]),

  /// The staging environment.
  staging(aliases: ["stag", "staging"]),

  /// The production environment.
  production(aliases: ["prod", "production"]);

  /// This is the file base name linked to the environment.
  ///
  /// If the file base name is null, the file name will be the environment name.
  final String? _fileBaseName;

  /// This is the base name of the file linked to the environment.
  String get fileBaseName => _fileBaseName ?? name;

  final List<String> _aliases;

  /// Enum constructor
  const ConfigEnvironmentType({
    String? fileName,
    List<String> aliases = const [],
  })  : _fileBaseName = fileName,
        _aliases = aliases;

  /// Try to parse a [ConfigEnvironmentType] from a string.
  ///
  /// If the string is not a valid [ConfigEnvironmentType], return null.
  static ConfigEnvironmentType? fromString(String? value) {
    if (value == null) {
      return null;
    }

    final lowerValue = value.toLowerCase();
    for (final env in ConfigEnvironmentType.values) {
      if (env._aliases.contains(lowerValue)) {
        return env;
      }
    }

    return null;
  }
}
