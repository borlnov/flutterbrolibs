enum ConfigEnvironmentType {
  development,
  staging,
  production;

  final String? _fileName;

  String get fileName => _fileName ?? name;

  const ConfigEnvironmentType({
    String? fileName,
  }) : _fileName = fileName;

  static ConfigEnvironmentType? fromString(String? value) {
    if (value == null) {
      return null;
    }

    final lowerValue = value.toLowerCase();
    for (final env in ConfigEnvironmentType.values) {
      if (env.name == lowerValue) {
        return env;
      }
    }

    return null;
  }
}
