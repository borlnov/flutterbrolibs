import 'package:equatable/equatable.dart';

class AModel extends Equatable {
  static const nameKey = 'name';
  static const ageKey = 'age';

  final String name;
  final int age;

  const AModel({
    required this.name,
    required this.age,
  });

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

  @override
  List<Object?> get props => [name, age];
}
