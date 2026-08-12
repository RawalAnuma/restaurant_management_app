import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';
import 'package:restaurant_management_app/screens/edit_food_screen.dart';

import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;

  const FoodCard({super.key, required this.food});

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Food'),
          content: Text('Are you sure you want to delete "${food.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final foodProvider = context.read<FoodProvider>();

    try {
      await foodProvider.deleteFood(food.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food deleted successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete food: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: food.image != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(food.image!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 65,
                      color: Colors.orange.shade300,
                    ),
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
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    food.categoryName,
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  food.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${food.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),

                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit),
                          color: Colors.blue.shade600,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditFoodScreen(food: food),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete),
                          color: Colors.red.shade600,
                          onPressed: () {
                            _confirmDelete(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
