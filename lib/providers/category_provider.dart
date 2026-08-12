import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<CategoryModel> categories = [];

  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get('/categories');

      final data = response['data'];

      categories = (data as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await apiService.delete('/categories/$id');

      categories.removeWhere((category) => category.id == id);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
