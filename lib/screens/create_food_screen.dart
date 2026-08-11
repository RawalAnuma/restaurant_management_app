import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/models/category_model.dart';
import 'package:restaurant_management_app/providers/category_provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';

class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({super.key});

  @override
  State<CreateFoodScreen> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  CategoryModel? _selectedCategory;
  bool _status = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
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
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final foodProvider = context.read<FoodProvider>();

                  try {
                    await foodProvider.createFood(
                      categoryId: _selectedCategory!.id,
                      name: _nameController.text.trim(),
                      description: _descriptionController.text.trim(),
                      price: double.parse(_priceController.text.trim()),
                      image: null,
                      status: _status,
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Food created successfully'),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create food: $e')),
                    );
                  }
                },

                child: const Text('Add Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
