import 'package:hive/hive.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';

part "day_profile_model.g.dart";

@HiveType(typeId: 4)
class DayProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<Template> tasks;

  DayProfile({
    required this.id,
    required this.name,
    this.tasks = const [],
  });

  DayProfile copyWith({
    String? id,
    String? name,
    List<Template>? tasks
  }) {
    return DayProfile(id: id ?? this.id, 
    name: name ?? this.name,
    tasks: tasks ?? this.tasks
    );
  }

  @override
  String toString() {
    return "DayProfile(name: $name, id: $id)";
  }
}