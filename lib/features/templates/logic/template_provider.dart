import "package:flutter/foundation.dart";
import '../data/template_model.dart';
import '../data/templates_repository.dart';

class TemplateProvider extends ChangeNotifier {
    final TemplatesRepository _repository;
    List<Template> _templates = [];
    List<Template> get templates => _templates;

    TemplateProvider(this._repository) {
        _loadTemplates();
    }

    Future<void> _loadTemplates() async {
        _templates = await _repository.getAll();
        notifyListeners();
    }

    Future<void> addTemplate(Template template) async {
        await _repository.save(template);
        _templates.add(template);
        notifyListeners();
    }

    Future<void> updateTemplate(Template template) async {
        await _repository.save(template);
        final index = _templates.indexWhere((t) => t.id == template.id);
        _templates[index] = template;
        notifyListeners();
    }

    Future<void> deleteTemplate(String id) async {
        await _repository.delete(id);
        _templates.removeWhere((t) => t.id == id);
        notifyListeners();
    }

    Template? getTemplateById(String id) {
    try {
      return _templates.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}