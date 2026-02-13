import "package:flutter/foundation.dart";
import '../data/settings_repository.dart';
import '../data/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  // private instance of settingsrepository
  final SettingsRepository _repository;

  // sets up possible instance of settings and
  // stores them
  Settings? _settings; 

  Settings? get settings => _settings;

  SettingsProvider(this._repository) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settings = await _repository.get();

    // if settings don't exist, create defaults
    _settings ??= Settings(
      timeGranularity: 15,
      darkMode: false,
      defaultCategoryId: null,
      );
    notifyListeners();
  }

  Future<void> update(Settings newSettings) async {
    _settings = newSettings;
    await _repository.save(newSettings);
    notifyListeners();
  }

  Future<void> setGranularity(int minutes) async {
    final updated = _settings!.copyWith(timeGranularity: minutes);
    await update(updated);
  }

  Future<void> setDarkMode(bool enabled) async {
    final updated = _settings!.copyWith(darkMode: enabled);
    await update(updated);
  }
}