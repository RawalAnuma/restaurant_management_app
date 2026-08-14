import 'package:flutter/material.dart';

import '../utils/api_constants.dart';

class FoodModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final String? image;
  final bool status;

  FoodModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.status,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    debugPrint('IMAGE FROM API: ${json['image']}');
    return FoodModel(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category']['name'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      image: json['image'] != null
          ? '${ApiConstants.baseUrl.replaceFirst('/api', '')}/storage/foods/${json['image'].toString().split('/').last}'
          : null,
      status: json['status'],
    );
  }
}
