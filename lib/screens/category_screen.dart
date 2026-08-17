import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import 'create_category_screen.dart';
import 'edit_category_screen.dart';
import '../widgets/category_card.dart';
import '../widgets/empty_category_state.dart';

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
          ? EmptyCategoryState(onAddCategory: _openCreateCategory)
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
                    return CategoryCard(
                      category: category,
                      icon: _getCategoryIcon(category.name),
                      onEdit: () => _openEditCategory(category),
                      onDelete: () => _deleteCategory(category),
                    );
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
