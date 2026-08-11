import 'package:flutter/material.dart';

import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: food.image != null
                ? Image.network(food.image!, fit: BoxFit.cover)
                : const Center(
                    child: Icon(Icons.restaurant, size: 60, color: Colors.grey),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  food.categoryName,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 8),

                Text(
                  food.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                Text(
                  'Rs. ${food.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
