import 'package:hive/hive.dart';

part "template_model.g.dart";

@HiveType(typeId: 3)
class Template extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Duration duration;

  @HiveField(3)
  final String? categoryId;

  @HiveField(4)
  final bool allowOverlap;

  @HiveField(5)
  final String? notes;

  Template({
    required this.id,
    required this.name,
    required this.duration,
    this.categoryId,
    this.allowOverlap = true,
    this.notes
  });

  Template copyWith({
    String? id,
    String? name,
    Duration? duration,
    String? categoryId,
    bool? allowOverlap,
    String? notes
  }) {
    return Template(id: id ?? this.id, 
    name: name ?? this.name, 
    duration: duration ?? this.duration, 
    categoryId: categoryId ?? this.categoryId,
    allowOverlap: allowOverlap ?? this.allowOverlap,
    notes: notes ?? this.notes);
  }

  @override
  String toString() {
    return "Template(id: $id, name: $name)";
  }
}