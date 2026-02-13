import "package:flutter/foundation.dart";
import '../data/task_model.dart';
import '../data/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider(this._repository) {
    _loadTasks();
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    _tasks = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.save(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _repository.save(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _repository.delete(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}