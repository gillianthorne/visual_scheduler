import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:visual_scheduler/features/categories/data/category_model.dart';
import 'package:visual_scheduler/features/categories/logic/category_provider.dart';
import 'package:visual_scheduler/features/day_profiles/data/day_profile_model.dart';
import 'package:visual_scheduler/features/day_profiles/data/profile_task_model.dart';
import 'package:visual_scheduler/features/settings/data/settings_model.dart';
import 'package:visual_scheduler/features/tasks/data/task_model.dart';
import 'package:visual_scheduler/features/tasks/data/task_repository.dart';
import 'package:visual_scheduler/features/templates/data/template_model.dart';
import 'features/tasks/logic/task_provider.dart';
import 'features/tasks/presentation/daily_timeline_screen.dart';
import 'features/tasks/data/duration_adapter.dart';

// main is asynchronous - when run we make sure it is initialzied then 
// await before we can run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await pauses just this function while these are running, so that the
  // app cannot be run without these two tasks, as that would cause an error
  await Hive.initFlutter();
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(ProfileTaskAdapter());
  Hive.registerAdapter(DayProfileAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TemplateAdapter());
  Hive.registerAdapter(SettingsAdapter());

  final taskBox = await Hive.openBox<Task>('tasksBox');
  final taskRepository = TaskRepository(Hive.box<Task>('tasksBox'));

  await Hive.openBox<Category>('categories');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(taskRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: VisualSchedulerApp(taskBox: taskBox),
    ),
  );

;
}

class VisualSchedulerApp extends StatelessWidget {
  final Box<Task> taskBox;
  const VisualSchedulerApp({super.key, required this.taskBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DailyTimelineScreen(),
    );
  }
  
}
