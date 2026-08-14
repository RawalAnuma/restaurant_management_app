import 'package:flutter/material.dart';
import 'package:restaurant_management_app/screens/profile_screen.dart';

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
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      DashboardScreen(
        onViewAllOrders: () {
          setState(() {
            _currentIndex = 3;
          });
        },
        onProfile: () {
          setState(() {
            _currentIndex = 4;
          });
        },
      ),
      const FoodScreen(),
      const CategoryScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Foods',
          ),

          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
