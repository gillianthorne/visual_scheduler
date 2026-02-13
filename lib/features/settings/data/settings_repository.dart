import 'package:hive/hive.dart';
import 'settings_model.dart';

class SettingsRepository {
  final Box<Settings> _box;

  SettingsRepository(this._box);

  Settings? get() {
    return _box.get('settings');
  }

  Future<void> save(Settings settings) async {
    await _box.put('settings', settings);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}