import 'package:hive/hive.dart';

part "task_model.g.dart";

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final Duration startOffset;

  @HiveField(3)
  final Duration duration;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final String? templateId;

  @HiveField(6)
  final bool allowOverlap;

  @HiveField(7)
  final bool isReminder;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.startOffset,
    required this.duration,
    this.categoryId,
    this.templateId,
    this.allowOverlap = true,
    this.isReminder = false,
    this.notes,
    required this.date
  });

  Task copyWith({
    String? id,
    String? title,
    Duration? startOffset,
    Duration? duration,
    String? categoryId,
    String? templateId,
    bool? allowOverlap,
    bool? isReminder,
    String? notes,
    DateTime? date
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      startOffset: startOffset ?? this.startOffset,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      templateId: templateId ?? this.templateId,
      allowOverlap: allowOverlap ?? this.allowOverlap,
      isReminder: isReminder ?? this.isReminder,
      notes: notes ?? this.notes,
      date: date ?? this.date
    );
  }

  @override
  String toString() {
    return "Task(title: $title, start: $startOffset, duration: $duration)";
  }
}