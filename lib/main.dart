import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FoodProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Management',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Management'),
        ),
        body: const Center(
          child: Text('Restaurant Management App'),
        ),
      ),
    );
  }
}

