import "package:flutter/foundation.dart" hide Category;
import '../data/category_model.dart';
import '../data/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider(this._repository) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await _repository.save(category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.save(category);

    final index = _categories.indexWhere((c) => c.id == category.id);
    _categories[index] = category;

    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

}