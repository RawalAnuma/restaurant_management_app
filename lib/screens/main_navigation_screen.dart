import 'package:flutter/material.dart';

import 'category_screen.dart';
import 'dashboard_screen.dart';
import 'food_screen.dart';
import 'order_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const Color primaryColor = Color(0xFFD35400);

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    FoodScreen(),
    CategoryScreen(),
    OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: Colors.white,

        indicatorColor: const Color(0xFFFFEFE5),

        elevation: 3,

        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            );
          }

          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF77706B),
          );
        }),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Color(0xFF77706B)),
            selectedIcon: Icon(Icons.dashboard, color: primaryColor),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.restaurant_menu_outlined,
              color: Color(0xFF77706B),
            ),
            selectedIcon: Icon(Icons.restaurant_menu, color: primaryColor),
            label: 'Foods',
          ),

          NavigationDestination(
            icon: Icon(Icons.category_outlined, color: Color(0xFF77706B)),
            selectedIcon: Icon(Icons.category, color: primaryColor),
            label: 'Categories',
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: Color(0xFF77706B)),
            selectedIcon: Icon(Icons.receipt_long, color: primaryColor),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
