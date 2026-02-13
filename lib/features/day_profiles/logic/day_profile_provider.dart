import 'package:flutter/foundation.dart';
import '../data/day_profile_model.dart';
import '../data/day_profile_repository.dart';

class DayProfileProvider extends ChangeNotifier {
  final DayProfileRepository _repository;
  List<DayProfile> _profiles = [];
  List<DayProfile> get profile => _profiles;

  DayProfileProvider(this._repository) {
    _loadProfiles();
    notifyListeners();
  }

  Future<void> _loadProfiles() async {
    _profiles = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addProfile(DayProfile profile) async {
    await _repository.save(profile);
    _profiles.add(profile);
    notifyListeners();
  }

  Future<void> updateProfile(DayProfile profile) async {
    await _repository.save(profile);
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
    }
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    await _repository.delete(id);
    _profiles.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  DayProfile? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}