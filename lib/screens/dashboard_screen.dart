import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';
import '../providers/category_provider.dart';
import '../providers/order_provider.dart';
import 'order_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color primaryColor = Color(0xFFD35400);
  static const Color backgroundColor = Color(0xFFF8F7F5);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<FoodProvider>().fetchFoods();
      context.read<CategoryProvider>().fetchCategories();
      context.read<OrderProvider>().fetchOrders();
    });
  }

  int _getPendingOrders(OrderProvider provider) {
    return provider.orders
        .where((order) => order.status.toLowerCase() == 'pending')
        .length;
  }

  int _getCompletedOrders(OrderProvider provider) {
    return provider.orders
        .where((order) => order.status.toLowerCase() == 'completed')
        .length;
  }

  Color _getStatusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFF6D9);

      case 'preparing':
        return const Color(0xFFFCEBDD);

      case 'ready':
        return const Color(0xFFE8F5E9);

      case 'completed':
        return const Color(0xFFE4F7EE);

      case 'cancelled':
        return const Color(0xFFFDE8E8);

      default:
        return const Color(0xFFF2F2F2);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD18A00);

      case 'preparing':
        return const Color(0xFFD35400);

      case 'ready':
        return const Color(0xFF238636);

      case 'completed':
        return const Color(0xFF159447);

      case 'cancelled':
        return const Color(0xFFD32F2F);

      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;

      case 'preparing':
        return Icons.restaurant;

      case 'ready':
        return Icons.check_circle_outline;

      case 'completed':
        return Icons.check_circle;

      case 'cancelled':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================
      // APP BAR
      // ==========================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            // Drawer/menu can be added later if needed.
          },
          icon: const Icon(Icons.menu, size: 21, color: Color(0xFF5B3A29)),
        ),

        title: const Text(
          'Admin',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await Future.wait([
            context.read<FoodProvider>().fetchFoods(),
            context.read<CategoryProvider>().fetchCategories(),
            context.read<OrderProvider>().fetchOrders(),
          ]);
        },
        child: Consumer3<FoodProvider, CategoryProvider, OrderProvider>(
          builder:
              (context, foodProvider, categoryProvider, orderProvider, child) {
                final pendingOrders = _getPendingOrders(orderProvider);
                final completedOrders = _getCompletedOrders(orderProvider);

                final recentOrders = orderProvider.orders.take(3).toList();

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 17, 12, 20),
                  children: [
                    // ==========================================
                    // GREETING
                    // ==========================================
                    const Text(
                      'Good Morning, Admin',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "Here's what's happening today.",
                      style: TextStyle(fontSize: 10, color: Color(0xFF6E625B)),
                    ),

                    const SizedBox(height: 17),

                    // ==========================================
                    // STAT CARDS
                    // ==========================================
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.restaurant_menu,
                            iconColor: primaryColor,
                            iconBackground: const Color(0xFFFFEFE5),
                            title: 'Total Foods',
                            value: foodProvider.foods.length.toString(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.category_outlined,
                            iconColor: const Color(0xFF42658C),
                            iconBackground: const Color(0xFFEFF5FF),
                            title: 'Categories',
                            value: categoryProvider.categories.length
                                .toString(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.shopping_bag_outlined,
                            iconColor: const Color(0xFFD59A00),
                            iconBackground: const Color(0xFFFFF8DA),
                            title: 'Pending Orders',
                            value: pendingOrders.toString(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle_outline,
                            iconColor: const Color(0xFF159447),
                            iconBackground: const Color(0xFFE8F9EF),
                            title: 'Completed',
                            value: completedOrders.toString(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // RECENT ORDERS HEADER
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Orders',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            // The parent navigation will handle Orders.
                            // This can later be connected to a tab controller.
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ==========================================
                    // RECENT ORDERS
                    // ==========================================
                    if (orderProvider.isLoading && recentOrders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      )
                    else if (recentOrders.isEmpty)
                      _EmptyOrdersCard()
                    else
                      ...recentOrders.map(
                        (order) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _RecentOrderCard(
                            orderId: order.id,
                            status: order.status,
                            itemCount: order.items.fold(
                              0,
                              (sum, item) => sum + item.quantity,
                            ),
                            total: order.total,
                            statusBackground: _getStatusBackground(
                              order.status,
                            ),
                            statusColor: _getStatusColor(order.status),
                            statusIcon: _getStatusIcon(order.status),
                          ),
                        ),
                      ),
                  ],
                );
              },
        ),
      ),
    );
  }
}

// ======================================================
// STAT CARD
// ======================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 27,
            width: 27,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 15),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6E625B)),
          ),

          const SizedBox(height: 1),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// RECENT ORDER CARD
// ======================================================

class _RecentOrderCard extends StatelessWidget {
  final int orderId;
  final String status;
  final int itemCount;
  final double total;
  final Color statusBackground;
  final Color statusColor;
  final IconData statusIcon;

  const _RecentOrderCard({
    required this.orderId,
    required this.status,
    required this.itemCount,
    required this.total,
    required this.statusBackground,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#ORD-${orderId.toString().padLeft(3, '0')}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 10, color: statusColor),
                    const SizedBox(width: 3),
                    Text(
                      _formatStatus(status),
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: const TextStyle(fontSize: 9, color: Color(0xFF6E625B)),
              ),

              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return 'Unknown';
    }

    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}

// ======================================================
// EMPTY ORDERS
// ======================================================

class _EmptyOrdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 32, color: Color(0xFFB7ADA6)),
          SizedBox(height: 8),
          Text(
            'No recent orders',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 3),
          Text(
            'Orders will appear here when available.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: Color(0xFF8A817B)),
          ),
        ],
      ),
    );
  }
}
