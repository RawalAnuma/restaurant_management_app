import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/auth_provider.dart';
import 'package:restaurant_management_app/providers/category_provider.dart';
import 'package:restaurant_management_app/providers/food_provider.dart';
import 'package:restaurant_management_app/providers/order_provider.dart';
import 'package:restaurant_management_app/screens/auth_check_screen.dart';
//import 'package:restaurant_management_app/screens/food_screen.dart';
//import 'package:restaurant_management_app/screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
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
      home: const AuthCheckScreen(),
    );
  }
}
