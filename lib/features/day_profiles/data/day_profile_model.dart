import 'package:hive/hive.dart';
import 'profile_task_model.dart';

part "day_profile_model.g.dart";

@HiveType(typeId: 4)
class DayProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<ProfileTask> tasks;

  @HiveField(3)
  List<int> repeatOnWeekdays;

  DayProfile({
    required this.id,
    required this.name,
    this.tasks = const [],
    this.repeatOnWeekdays = const[]
  });

  DayProfile copyWith({
    String? id,
    String? name,
    List<ProfileTask>? tasks,
    List<int>? repeatOnWeekdays
  }) {
    return DayProfile(id: id ?? this.id, 
    name: name ?? this.name,
    tasks: tasks ?? this.tasks,
    repeatOnWeekdays: repeatOnWeekdays ?? this.repeatOnWeekdays);
  }

  @override
  String toString() {
    return "DayProfile(name: $name, id: $id)";
  }
}