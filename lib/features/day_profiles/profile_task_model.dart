import 'package:hive/hive.dart';

part 'profile_task_model.g.dart';


@HiveType(typeId: 5)
class ProfileTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final Duration startOffset;

  @HiveField(3)
  final String? categoryId;

  @HiveField(4)
  final String? templateId;

  @HiveField(5)
  final bool allowOverlap;

  @HiveField(6)
  final bool isReminder;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final Duration duration;

  ProfileTask({
    required this.id,
    required this.title,
    required this.startOffset,
    required this.duration,
    this.categoryId,
    this.templateId,
    this.allowOverlap = true,
    this.isReminder = false,
    this.notes,
  });
  ProfileTask copyWith({
    String? id,
    String? title,
    Duration? startOffset,
    Duration? duration,
    String? categoryId,
    String? templateId,
    bool? allowOverlap,
    bool? isReminder,
    String? notes,
  }) {
    return ProfileTask(
      id: id ?? this.id,
      title: title ?? this.title,
      startOffset: startOffset ?? this.startOffset,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      templateId: templateId ?? this.templateId,
      allowOverlap: allowOverlap ?? this.allowOverlap,
      isReminder: isReminder ?? this.isReminder,
      notes: notes ?? this.notes,
    );
  }
  @override
  String toString() {
    return "ProfileTask(id: $id, title: $title, startOffset: $startOffset, duration: $duration)";
  }
}