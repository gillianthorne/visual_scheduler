import "category_model.dart";
import "package:hive/hive.dart";

class CategoryRepository {
  final Box<Category> _box;
  CategoryRepository(this._box);
  List<Category> getAll() => _box.values.toList();

  Future<void> save(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}