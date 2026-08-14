import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../providers/food_provider.dart';

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
  File? _selectedImage;
  bool _isSubmitting = false;

  static const Color primaryOrange = Color(0xFFD35400);
  static const Color backgroundColor = Color(0xFFF8F7F5);
  static const Color secondaryText = Color(0xFF6E625B);
  static const Color borderColor = Color(0xFFE0DDD9);

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null || !mounted) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  Future<void> _createFood() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBar('Please select a category');
      return;
    }

    if (_selectedImage == null) {
      _showSnackBar('Please select a food image');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final foodProvider = context.read<FoodProvider>();

    try {
      await foodProvider.createFoodWithImage(
        categoryId: _selectedCategory!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        image: _selectedImage!,
        status: _status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food created successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showSnackBar('Failed to create food: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: secondaryText, fontSize: 14),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _sectionTitle(String title, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (required)
            const Text(
              ' *',
              style: TextStyle(
                color: primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
        ),
        title: const Text(
          'Add Food',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const Text(
                'Create a new food item',
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),

              const SizedBox(height: 24),

              // ---------------- IMAGE ----------------
              _sectionTitle('Food Image', required: true),

              GestureDetector(
                onTap: _pickImage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedImage != null
                          ? primaryOrange
                          : borderColor,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE8D9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: primaryOrange,
                                size: 27,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Add Food Image',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Tap to select an image from gallery',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_selectedImage!, fit: BoxFit.cover),

                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.55),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _pickImage,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                  tooltip: 'Change image',
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 10),

              if (_selectedImage != null)
                Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      size: 18,
                      color: primaryOrange,
                    ),
                    label: const Text(
                      'Change Image',
                      style: TextStyle(
                        color: primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // ---------------- CATEGORY ----------------
              _sectionTitle('Category', required: true),

              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  if (categoryProvider.isLoading) {
                    return Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryOrange,
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField<CategoryModel>(
                    initialValue: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: secondaryText,
                    ),
                    decoration: _inputDecoration(
                      hintText: 'Select category',
                      prefixIcon: const Icon(
                        Icons.category_outlined,
                        color: secondaryText,
                        size: 20,
                      ),
                    ),
                    items: categoryProvider.categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 14),
                        ),
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

              const SizedBox(height: 20),

              // ---------------- NAME ----------------
              _sectionTitle('Food Name', required: true),

              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  hintText: 'Enter food name',
                  prefixIcon: const Icon(
                    Icons.restaurant_menu_outlined,
                    color: secondaryText,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter food name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ---------------- DESCRIPTION ----------------
              _sectionTitle('Description', required: true),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: _inputDecoration(
                  hintText: 'Describe your food...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 58),
                    child: Icon(
                      Icons.description_outlined,
                      color: secondaryText,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ---------------- PRICE ----------------
              _sectionTitle('Price', required: true),

              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  hintText: 'Enter price',
                  prefixIcon: const Icon(
                    Icons.currency_rupee,
                    color: secondaryText,
                    size: 20,
                  ),
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

              const SizedBox(height: 20),

              // ---------------- AVAILABILITY ----------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Make this food available for ordering',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _status,
                      activeThumbColor: Colors.white,
                      activeTrackColor: primaryOrange,
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- ADD BUTTON ----------------
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _createFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryOrange.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add Food',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
