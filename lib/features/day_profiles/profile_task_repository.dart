import 'package:hive/hive.dart';
import 'profile_task_model.dart';

class ProfileTaskRepository {
  final Box<ProfileTask> _box;
  ProfileTaskRepository(this._box);
  List<ProfileTask> getAll() => _box.values.toList();
  ProfileTask? getById(String id) => _box.get(id);

  Future<void> save(ProfileTask task) async {
    await _box.put(task.id, task);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}