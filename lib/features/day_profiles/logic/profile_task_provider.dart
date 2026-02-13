import 'package:flutter/foundation.dart';
import '../data/profile_task_model.dart';
import '../data/profile_task_repository.dart';

class ProfileTaskProvider extends ChangeNotifier {
  final ProfileTaskRepository _repository;
  List<ProfileTask> _profileTasks = [];
  List<ProfileTask> get profileTasks => _profileTasks;

  ProfileTaskProvider(this._repository) {
    _loadProfileTasks();
  }

  Future<void> _loadProfileTasks() async {
    _profileTasks = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addProfileTask(ProfileTask task) async {
    await _repository.save(task);
    _profileTasks.add(task);
    notifyListeners();
  }

  Future<void> updateProfileTask(ProfileTask task) async {
    await _repository.save(task);
    final index = _profileTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _profileTasks[index] = task;
    }
    notifyListeners();
  }

  Future<void> deleteProfileTask(String id) async {
    await _repository.delete(id);
    _profileTasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  ProfileTask? getProfileTaskById(String id) {
    try {
      return _profileTasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}