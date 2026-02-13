import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../features/tasks/data/task_model.dart'; // import your model

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasksBox');
}