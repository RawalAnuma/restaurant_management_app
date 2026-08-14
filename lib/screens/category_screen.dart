import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import 'create_category_screen.dart';
import 'edit_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const Color primaryOrange = Color(0xFFB94700);
  static const Color darkOrange = Color(0xFF9E3D00);
  static const Color backgroundColor = Color(0xFFF9F8F6);
  static const Color textColor = Color(0xFF171717);
  static const Color secondaryText = Color(0xFF8A7D75);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<CategoryProvider>().fetchCategories();
    });
  }

  IconData _getCategoryIcon(String name) {
    final category = name.toLowerCase();

    if (category.contains('pizza')) {
      return Icons.local_pizza_outlined;
    }

    if (category.contains('burger')) {
      return Icons.lunch_dining_outlined;
    }

    if (category.contains('drink') || category.contains('beverage')) {
      return Icons.local_cafe_outlined;
    }

    if (category.contains('dessert')) {
      return Icons.icecream_outlined;
    }

    if (category.contains('salad')) {
      return Icons.eco_outlined;
    }

    if (category.contains('chicken')) {
      return Icons.set_meal_outlined;
    }

    return Icons.restaurant_menu_outlined;
  }

  void _openCreateCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
    ).then((_) {
      if (!mounted) return;

      context.read<CategoryProvider>().fetchCategories();
    });
  }

  void _openEditCategory(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCategoryScreen(category: category)),
    ).then((_) {
      if (!mounted) return;

      context.read<CategoryProvider>().fetchCategories();
    });
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Category',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to delete "${category.name}"?',
            style: const TextStyle(color: secondaryText, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: secondaryText),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    try {
      await context.read<CategoryProvider>().deleteCategory(category.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildCategoryCard(CategoryModel category) {
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
          // CATEGORY ICON
          Container(
            height: 57,
            width: 57,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getCategoryIcon(category.name),
              color: primaryOrange,
              size: 29,
            ),
          ),

          const SizedBox(width: 18),

          // CATEGORY NAME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Food category',
                  style: TextStyle(color: secondaryText, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // EDIT BUTTON
          _buildActionButton(
            icon: Icons.edit_outlined,
            color: primaryOrange,
            onPressed: () {
              _openEditCategory(category);
            },
          ),

          const SizedBox(width: 8),

          // DELETE BUTTON
          _buildActionButton(
            icon: Icons.delete_outline,
            color: Colors.red,
            onPressed: () {
              _deleteCategory(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
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

  Widget _buildEmptyState() {
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
                color: primaryOrange,
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
              style: TextStyle(color: secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openCreateCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
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

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,

      // APP BAR
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Color(0xFF3F3028), size: 24),
        ),

        title: const Text(
          'Restaurant Admin',
          style: TextStyle(
            color: darkOrange,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              // Search can be implemented later.
            },
            icon: const Icon(Icons.search, color: Color(0xFF3F3028), size: 24),
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : categoryProvider.categories.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              color: primaryOrange,
              onRefresh: () {
                return categoryProvider.fetchCategories();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Manage your menu organization',
                    style: TextStyle(color: Color(0xFF6E5548), fontSize: 16),
                  ),

                  const SizedBox(height: 28),

                  ...categoryProvider.categories.map((category) {
                    return _buildCategoryCard(category);
                  }),
                ],
              ),
            ),

      // ADD CATEGORY BUTTON
      floatingActionButton: FloatingActionButton(
        heroTag: 'category_add_button',
        onPressed: _openCreateCategory,
        backgroundColor: darkOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add, size: 31),
      ),
    );
  }
}
