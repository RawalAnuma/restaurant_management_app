import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isSubmitting = false;

  static const Color primaryOrange = Color(0xFFB94700);
  static const Color darkOrange = Color(0xFF9E3D00);
  static const Color backgroundColor = Color(0xFFF9F8F6);
  static const Color textColor = Color(0xFF171717);
  static const Color secondaryText = Color(0xFF8A7D75);
  static const Color borderColor = Color(0xFFE0DDD9);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryProvider = context.read<CategoryProvider>();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await categoryProvider.createCategory(_nameController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category created successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create category: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'e.g. Pizza',
      hintStyle: const TextStyle(color: secondaryText, fontSize: 14),
      prefixIcon: const Icon(
        Icons.category_outlined,
        color: secondaryText,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: primaryOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
        ),

        title: const Text(
          'Add Category',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            children: [
              // HEADER ICON
              Center(
                child: Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E8),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: primaryOrange,
                    size: 38,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  'Create a Category',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 7),

              const Center(
                child: Text(
                  'Organize your menu by creating a new food category.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // FORM CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category Name',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_isSubmitting) {
                          _createCategory();
                        }
                      },
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter category name';
                        }

                        if (value.trim().length < 2) {
                          return 'Category name must be at least 2 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Example: Pizza, Burgers, Drinks, Desserts',
                      style: TextStyle(color: secondaryText, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // CREATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _createCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: darkOrange.withValues(alpha: 0.6),
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
                            Icon(Icons.add, size: 21),
                            SizedBox(width: 8),
                            Text(
                              'Create Category',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
