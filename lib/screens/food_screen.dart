import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';
import '../widgets/food_card.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FoodProvider>().fetchFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Foods')),
      body: foodProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : foodProvider.foods.isEmpty
          ? const Center(child: Text('No foods found'))
          : ListView.builder(
              itemCount: foodProvider.foods.length,
              itemBuilder: (context, index) {
                final food = foodProvider.foods[index];
                return FoodCard(food: food);
              },
            ),
    );
  }
}
