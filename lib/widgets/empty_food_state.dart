import 'package:flutter/material.dart';

class EmptyFoodState extends StatelessWidget {
  final bool hasFilters;

  const EmptyFoodState({super.key, required this.hasFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEFE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_outlined,
                size: 42,
                color: Color(0xFFD35400),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              hasFilters ? 'No foods found' : 'No foods available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4A3024),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hasFilters
                  ? 'Try changing your search or category filter.'
                  : 'Add your first food to get started.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF8A817B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
