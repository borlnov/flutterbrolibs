abstract final class BoolUtility {
  static const List<String> trueValues = ['true', '1', 'yes', 'on'];
  static const List<String> falseValues = ['false', '0', 'no', 'off'];

  static bool? tryParse(String value) {
    if (trueValues.contains(value)) {
      return true;
    }

    if (falseValues.contains(value)) {
      return false;
    }

    return null;
  }

  static bool parse(String value) => tryParse(value)!;
}
