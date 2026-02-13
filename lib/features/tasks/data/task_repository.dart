import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskRepository {
  final Box<Task> _box;
  TaskRepository(this._box);
  List<Task> getAll() => _box.values.toList();

  Future<void> save(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}