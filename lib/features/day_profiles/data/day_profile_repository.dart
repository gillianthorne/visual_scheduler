import "package:hive/hive.dart";
import "day_profile_model.dart";

class DayProfileRepository {
  final Box<DayProfile> _box;
  DayProfileRepository(this._box);
  List<DayProfile> getAll() => _box.values.toList();

  Future<void> save(DayProfile profile) async {
    await _box.put(profile.id, profile);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}