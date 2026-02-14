import 'package:flutter/foundation.dart' hide Category;
import 'package:hive/hive.dart';

import '../data/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final Box<Category> _box = Hive.box<Category>('categories');

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = _box.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
    await _loadCategories(); // reload from Hive
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
    await _loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
    await _loadCategories();
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  int get nextSortOrder {
    if (_box.isEmpty) return 0;
    return _box.values.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
  }
}