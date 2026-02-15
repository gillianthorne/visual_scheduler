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

  List<Task> tasksForDate(DateTime date) {
    return _tasks.where((task) {
      return task.date.year == date.year &&
      task.date.month == date.month &&
      task.date.day == date.day;
    }).toList();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearCategory(String id) {
    for (Task task in tasks) {
      if (task.categoryId == id) {
        Task newTask = task.copyWith(
          id: task.id,
          title: task.title,
          startOffset: task.startOffset,
          duration: task.duration,
          categoryId: null,
          templateId: task.templateId,
          allowOverlap: task.allowOverlap,
          isReminder: task.isReminder,
          notes: task.notes,
          date: task.date          
        );
        deleteTask(task.id);
        addTask(newTask);
      }
    }
  }
}