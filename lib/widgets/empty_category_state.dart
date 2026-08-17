import 'package:flutter/material.dart';

class EmptyCategoryState extends StatelessWidget {
  final VoidCallback onAddCategory;

  const EmptyCategoryState({super.key, required this.onAddCategory});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 38,
                color: Color(0xFFB94700),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No Categories Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 7),

            const Text(
              'Create a category to organize your menu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A7D75), fontSize: 14),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onAddCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB94700),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
