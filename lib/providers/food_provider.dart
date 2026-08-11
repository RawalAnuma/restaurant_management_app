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

      foods = (data as List)
          .map((food) => FoodModel.fromJson(food))
          .toList();
    } catch (e) {
      debugPrint('Error fetching foods: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
