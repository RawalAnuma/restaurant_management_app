import 'package:flutter/material.dart';
import 'package:restaurant_management_app/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 57,
            width: 57,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFFB94700), size: 29),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Food category',
                  style: TextStyle(color: Color(0xFF8A7D75), fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          _ActionButton(
            icon: Icons.edit_outlined,
            color: const Color(0xFFB94700),
            onPressed: onEdit,
          ),

          const SizedBox(width: 8),

          _ActionButton(
            icon: Icons.delete_outline,
            color: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF8F5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 43,
          width: 43,
          child: Icon(icon, color: color, size: 21),
        ),
      ),
    );
  }
}
