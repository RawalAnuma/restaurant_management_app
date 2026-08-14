import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;
  bool _isSubmitting = false;

  static const Color primaryOrange = Color(0xFFD35400);
  static const Color backgroundColor = Color(0xFFF8F7F5);
  static const Color secondaryText = Color(0xFF6E625B);
  static const Color borderColor = Color(0xFFE0DDD9);

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

  Future<void> _updateFood() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBar('Please select a category');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final foodProvider = context.read<FoodProvider>();

    try {
      if (_selectedImage != null) {
        // New image selected
        await foodProvider.updateFoodWithImage(
          id: widget.food.id,
          categoryId: _selectedCategory!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          image: _selectedImage!,
          status: _status,
        );
      } else {
        // Keep existing image
        await foodProvider.updateFood(
          id: widget.food.id,
          categoryId: _selectedCategory!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          status: _status,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showSnackBar('Failed to update food: $e');
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

  Widget _buildImageSection() {
    final hasNewImage = _selectedImage != null;
    final hasExistingImage =
        widget.food.image != null && widget.food.image!.isNotEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasNewImage ? primaryOrange : borderColor,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasNewImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(_selectedImage!, fit: BoxFit.cover),
                      _editImageButton(),
                    ],
                  )
                : hasExistingImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.food.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imageErrorWidget();
                        },
                      ),
                      _editImageButton(),
                    ],
                  )
                : _emptyImageWidget(),
          ),
        ),

        const SizedBox(height: 10),

        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.photo_library_outlined,
            size: 18,
            color: primaryOrange,
          ),
          label: Text(
            hasNewImage ? 'Change Image' : 'Change Food Image',
            style: const TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _editImageButton() {
    return Positioned(
      right: 12,
      top: 12,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: _pickImage,
          icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 19),
          tooltip: 'Change image',
        ),
      ),
    );
  }

  Widget _emptyImageWidget() {
    return Column(
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
          'No Food Image',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Tap to select an image from gallery',
          style: TextStyle(fontSize: 12, color: secondaryText),
        ),
      ],
    );
  }

  Widget _imageErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.broken_image_outlined, size: 45, color: secondaryText),
        const SizedBox(height: 8),
        const Text(
          'Unable to load image',
          style: TextStyle(color: secondaryText, fontSize: 13),
        ),
      ],
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
          'Edit Food',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const Text(
                'Update food information',
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),

              const SizedBox(height: 24),

              // IMAGE
              _sectionTitle('Food Image', required: true),

              _buildImageSection(),

              const SizedBox(height: 12),

              // CATEGORY
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
                    items: categoryProvider.categories
                        .map(
                          (category) => DropdownMenuItem<CategoryModel>(
                            value: category,
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
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

              // FOOD NAME
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

              // DESCRIPTION
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

              // PRICE
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

              // AVAILABILITY
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
                      child: Icon(
                        _status
                            ? Icons.check_circle_outline
                            : Icons.remove_circle_outline,
                        color: _status ? Colors.green : secondaryText,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _status
                                ? 'This food is available for ordering'
                                : 'This food is currently unavailable',
                            style: const TextStyle(
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

              // UPDATE BUTTON
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateFood,
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
                              'Update Food',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.check_rounded, size: 20),
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
