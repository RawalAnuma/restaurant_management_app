import 'package:flutter/material.dart';

import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodCard({
    super.key,
    required this.food,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color primaryColor = Color(0xFFD35400);
  static const Color darkBrown = Color(0xFF4A3024);

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = food.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: food.image != null && food.image!.isNotEmpty
                      ? Image.network(
                          food.image!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _ImagePlaceholder(isAvailable: isAvailable);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Container(
                              color: const Color(0xFFF0EEEC),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          },
                        )
                      : _ImagePlaceholder(isAvailable: isAvailable),
                ),

                // AVAILABILITY
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? const Color(0xFF2E9B57)
                                : const Color(0xFFD32F2F),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAvailable ? 'Available' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isAvailable
                                ? const Color(0xFF247A43)
                                : const Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // INFORMATION
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: darkBrown,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEFE5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Rs. ${food.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 15,
                        color: Color(0xFF8A817B),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8A817B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(height: 1, color: const Color(0xFFF0EEEC)),

                  const SizedBox(height: 11),

                  // ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          label: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF42658C),
                            side: const BorderSide(color: Color(0xFFDCE3EA)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline, size: 17),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD32F2F),
                            side: const BorderSide(color: Color(0xFFF0D5D5)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final bool isAvailable;

  const _ImagePlaceholder({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFECEBE9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: isAvailable
                  ? const Color(0xFFB8B1AB)
                  : const Color(0xFFE0B6A6),
            ),

            const SizedBox(height: 8),

            Text(
              'No image available',
              style: TextStyle(
                fontSize: 12,
                color: isAvailable
                    ? const Color(0xFF8A817B)
                    : const Color(0xFFB9826D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
