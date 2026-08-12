import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/auth_provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';
import 'package:restaurant_management_app/screens/create_food_screen.dart';
import 'package:restaurant_management_app/screens/login_screen.dart';
import 'package:restaurant_management_app/screens/order_screen.dart';
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
      if (!mounted) return;
      context.read<FoodProvider>().fetchFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();

              try {
                await authProvider.logout();

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            },
          ),
        ],
      ),
      body: foodProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : foodProvider.foods.isEmpty
          ? const Center(child: Text('No foods found'))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: foodProvider.foods.length,
              itemBuilder: (context, index) {
                final food = foodProvider.foods[index];
                return FoodCard(food: food);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateFoodScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
