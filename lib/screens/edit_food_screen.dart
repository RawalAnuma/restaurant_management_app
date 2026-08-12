import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/food_model.dart';
import '../providers/category_provider.dart';
import '../providers/food_provider.dart';

class EditFoodScreen extends StatefulWidget {
  final FoodModel food;

  const EditFoodScreen({super.key, required this.food});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  CategoryModel? _selectedCategory;
  late bool _status;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.food.name);

    _descriptionController = TextEditingController(
      text: widget.food.description,
    );

    _priceController = TextEditingController(
      text: widget.food.price.toString(),
    );

    _status = widget.food.status;

    Future.microtask(() {
      if (!mounted) return;

      final categoryProvider = context.read<CategoryProvider>();

      categoryProvider.fetchCategories().then((_) {
        if (!mounted) return;

        final categories = categoryProvider.categories;

        for (final category in categories) {
          if (category.id == widget.food.categoryId) {
            setState(() {
              _selectedCategory = category;
            });
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  Future<void> _updateFood() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final foodProvider = context.read<FoodProvider>();

    try {
      await foodProvider.updateFood(
        id: widget.food.id,
        categoryId: _selectedCategory!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        image: widget.food.image,
        status: _status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update food: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Food')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  if (categoryProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return DropdownButtonFormField<CategoryModel>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryProvider.categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }

                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter food name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }

                  final price = double.tryParse(value);

                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Available'),
                value: _status,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _updateFood,
                child: const Text('Update Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
