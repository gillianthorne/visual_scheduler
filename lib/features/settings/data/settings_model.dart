import 'package:hive/hive.dart';

part "settings_model.g.dart";

@HiveType(typeId: 5)
class Settings extends HiveObject {
  @HiveField(0)
  final int timeGranularity;

  @HiveField(1)
  final bool darkMode;

  @HiveField(2)
  final String? defaultCategoryId;

  @HiveField(3)
  final bool showCompletedTasks;

  Settings({
    this.timeGranularity = 15,
    this.darkMode = false,
    this.defaultCategoryId,
    this.showCompletedTasks = true,
  });

  Settings copyWith({
    int? timeGranularity,
    bool? darkMode,
    String? defaultCategoryId,
    bool? showCompletedTasks,
  }) {
    return Settings(
      timeGranularity: timeGranularity ?? this.timeGranularity,
      darkMode: darkMode ?? this.darkMode,
      defaultCategoryId: defaultCategoryId ?? this.defaultCategoryId,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
    );
  }

  @override
  String toString() {
    return "Settings(timeGranularity: $timeGranularity, darkMode: $darkMode)";
  }
}