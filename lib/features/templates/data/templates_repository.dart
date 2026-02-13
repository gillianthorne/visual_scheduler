import 'package:hive/hive.dart';
import 'template_model.dart';

class TemplatesRepository {
  final Box<Template> _box;
  TemplatesRepository(this._box);
  List<Template> getAll() => _box.values.toList();

  Future<void> save(Template template) async {
    await _box.put(template.id, template);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}