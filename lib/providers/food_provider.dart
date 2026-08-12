import 'package:flutter/material.dart';
import 'package:restaurant_management_app/models/food_model.dart';
import 'package:restaurant_management_app/services/api_service.dart';

class FoodProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<FoodModel> foods = [];

  bool isLoading = false;

  Future<void> fetchFoods() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get('/foods');
      final data = response['data'];

      foods = (data as List).map((food) => FoodModel.fromJson(food)).toList();
    } catch (e) {
      debugPrint('Error fetching foods: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createFood({
    required int categoryId,
    required String name,
    required String description,
    required double price,
    String? image,
    required bool status,
  }) async {
    try {
      await apiService.post('/foods', {
        'category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
        'status': status,
      });

      await fetchFoods();
    } catch (e) {
      debugPrint('Error creating food: $e');
      rethrow;
    }
  }

  Future<void> updateFood({
    required int id,
    required int categoryId,
    required String name,
    required String description,
    required double price,
    String? image,
    required bool status,
  }) async {
    try {
      await apiService.put('/foods/$id', {
        'category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
        'status': status,
      });

      await fetchFoods();
    } catch (e) {
      debugPrint('Error updating food: $e');
      rethrow;
    }
  }

  Future<void> deleteFood(int id) async {
    try {
      await apiService.delete('/foods/$id');

      await fetchFoods();
    } catch (e) {
      debugPrint('Error deleting food: $e');
      rethrow;
    }
  }
}
