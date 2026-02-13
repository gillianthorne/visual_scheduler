import 'package:hive/hive.dart';

part "category_model.g.dart";

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int colourValue;

  @HiveField(3)
  final String? iconName;

  @HiveField(4)
  int sortOrder;

  Category({
    required this.id,
    required this.name,
    required this.colourValue,
    this.iconName,
    required this.sortOrder
  });

  Category copyWith({
    String? id,
    String? name,
    int? colourValue,
    String? iconName,
    int? sortOrder
  }) {
    return Category(id: id ?? this.id,
      name: name ?? this.name,
      colourValue: colourValue ?? this.colourValue, 
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder);
  }

  @override
  String toString() {
    return "Category(id: $id, name: $name)";
  }
}