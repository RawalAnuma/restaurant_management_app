import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/auth_provider.dart';

import '../models/category_model.dart';
import '../models/food_model.dart';
import '../providers/category_provider.dart';
import '../providers/food_provider.dart';
import 'create_food_screen.dart';
import 'edit_food_screen.dart';
import 'login_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  static const Color primaryColor = Color(0xFFD35400);
  static const Color darkBrown = Color(0xFF4A3024);
  static const Color backgroundColor = Color(0xFFF8F7F5);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<FoodProvider>().fetchFoods();
      context.read<CategoryProvider>().fetchCategories();
    });

    _searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<FoodModel> _getFilteredFoods(FoodProvider provider) {
    return provider.foods.where((food) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          food.name.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == null || food.categoryId == _selectedCategory!.id;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _showCategoryFilter(
    BuildContext context,
    List<CategoryModel> categories,
  ) async {
    final selected = await showModalBottomSheet<CategoryModel?>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkBrown,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: primaryColor,
                    ),
                  ),
                  title: const Text(
                    'All Foods',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Show all food items',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: _selectedCategory == null
                      ? const Icon(Icons.check_circle, color: primaryColor)
                      : null,
                  onTap: () {
                    Navigator.pop(sheetContext, null);
                  },
                ),

                const SizedBox(height: 8),

                if (categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        final isSelected = _selectedCategory?.id == category.id;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.category_outlined,
                              color: Color(0xFF42658C),
                            ),
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: primaryColor,
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(sheetContext, category);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _selectedCategory = selected;
    });
  }

  Future<void> _deleteFood(FoodModel food) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Food',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: darkBrown,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${food.name}"?',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    try {
      await context.read<FoodProvider>().deleteFood(food.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete food: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openCreateFood() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateFoodScreen()),
    );

    if (!mounted) return;

    await context.read<FoodProvider>().fetchFoods();
  }

  Future<void> _openEditFood(FoodModel food) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditFoodScreen(food: food)),
    );

    if (!mounted) return;

    await context.read<FoodProvider>().fetchFoods();
  }

  Future<void> _logout() async {
    try {
      await context.read<AuthProvider>().logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.logout, color: primaryColor),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: darkBrown,
                    ),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sign out of your account',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _logout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final filteredFoods = _getFilteredFoods(foodProvider);

    return Scaffold(
      backgroundColor: backgroundColor,

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          onPressed: _showLogoutSheet,
          icon: const Icon(Icons.menu, size: 25, color: darkBrown),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Menu',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: darkBrown,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage your restaurant foods',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8A817B),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search, size: 25, color: darkBrown),
          ),

          const SizedBox(width: 6),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await Future.wait([
            context.read<FoodProvider>().fetchFoods(),
            context.read<CategoryProvider>().fetchCategories(),
          ]);
        },

        child: Column(
          children: [
            // =================================================
            // SEARCH + FILTER
            // =================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE3DED9)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(fontSize: 14, color: darkBrown),
                        decoration: InputDecoration(
                          hintText: 'Search food...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9B928C),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 21,
                            color: Color(0xFF8A817B),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                  icon: const Icon(Icons.close, size: 18),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        _showCategoryFilter(
                          context,
                          categoryProvider.categories,
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE3DED9)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.tune, size: 21, color: darkBrown),

                            if (_selectedCategory != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================
            // SELECTED CATEGORY
            // =================================================
            if (_selectedCategory != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 15,
                            color: primaryColor,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            _selectedCategory!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(width: 5),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // =================================================
            // FOOD COUNT
            // =================================================
            if (filteredFoods.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  children: [
                    Text(
                      '${filteredFoods.length} ${filteredFoods.length == 1 ? 'Food' : 'Foods'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: darkBrown,
                      ),
                    ),

                    const Spacer(),

                    if (_selectedCategory != null || _searchQuery.isNotEmpty)
                      const Text(
                        'Filtered results',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A817B),
                        ),
                      ),
                  ],
                ),
              ),

            // =================================================
            // FOOD LIST
            // =================================================
            Expanded(
              child: foodProvider.isLoading && foodProvider.foods.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : filteredFoods.isEmpty
                  ? _EmptyFoodState(
                      hasFilters:
                          _searchQuery.isNotEmpty || _selectedCategory != null,
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 100),
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods[index];

                        return _FoodCard(
                          food: food,
                          categoryName: _categoryName(
                            categoryProvider.categories,
                            food.categoryId,
                          ),
                          onEdit: () => _openEditFood(food),
                          onDelete: () => _deleteFood(food),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // =====================================================
      // ADD FOOD
      // =====================================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: _openCreateFood,
        icon: const Icon(Icons.add, size: 23),
        label: const Text(
          'Add Food',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String _categoryName(List<CategoryModel> categories, int categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category.name;
      }
    }

    return 'Category';
  }
}

// =========================================================
// FOOD CARD
// =========================================================

class _FoodCard extends StatelessWidget {
  final FoodModel food;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FoodCard({
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
            
            // Image
            
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

                // Dark gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                ),

                // Availability
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


// Image Placeholder


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


// Empty State


class _EmptyFoodState extends StatelessWidget {
  final bool hasFilters;

  const _EmptyFoodState({required this.hasFilters});

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
