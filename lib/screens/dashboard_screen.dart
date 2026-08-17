import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';
import '../providers/category_provider.dart';
import '../providers/order_provider.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onViewAllOrders;
  final VoidCallback onProfile;
  const DashboardScreen({
    super.key,
    required this.onViewAllOrders,
    required this.onProfile,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color primaryColor = Color(0xFFD35400);
  static const Color backgroundColor = Color(0xFFF8F7F5);
  static const Color textColor = Color(0xFF2D2926);
  static const Color secondaryTextColor = Color(0xFF7A7069);

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
        return const Color(0xFFFFF4D6);

      case 'preparing':
        return const Color(0xFFFFE9DC);

      case 'ready':
        return const Color(0xFFE8F5E9);

      case 'completed':
        return const Color(0xFFE1F5EA);

      case 'cancelled':
        return const Color(0xFFFDE8E8);

      default:
        return const Color(0xFFF1F1F1);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFC47D00);

      case 'preparing':
        return primaryColor;

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
        return Icons.access_time_rounded;

      case 'preparing':
        return Icons.restaurant_rounded;

      case 'ready':
        return Icons.check_circle_outline_rounded;

      case 'completed':
        return Icons.check_circle_rounded;

      case 'cancelled':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,

        // Adds space at the top
        toolbarHeight: 85,

        titleSpacing: 20,

        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Restaurant Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Management Dashboard',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: GestureDetector(
              onTap: widget.onProfile,
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 22,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),

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
          builder: (context, foodProvider, categoryProvider, orderProvider, child) {
            final pendingOrders = _getPendingOrders(orderProvider);
            final completedOrders = _getCompletedOrders(orderProvider);

            final recentOrders = orderProvider.orders.take(4).toList();

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),

              children: [
                // WELCOME CARD
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD35400), Color(0xFFE87525)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.20),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello, Admin 👋',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              "Here's what's happening\nin your restaurant today.",
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 62,
                        width: 62,

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.restaurant_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // OVERVIEW TITLE
                const Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'A quick look at your restaurant',
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.restaurant_menu_rounded,
                        iconColor: primaryColor,
                        iconBackground: const Color(0xFFFFEFE5),
                        title: 'Total Foods',
                        value: foodProvider.foods.length.toString(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _StatCard(
                        icon: Icons.category_rounded,
                        iconColor: const Color(0xFF42658C),
                        iconBackground: const Color(0xFFEAF2FC),
                        title: 'Categories',
                        value: categoryProvider.categories.length.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pending_actions_rounded,
                        iconColor: const Color(0xFFC47D00),
                        iconBackground: const Color(0xFFFFF4D6),
                        title: 'Pending Orders',
                        value: pendingOrders.toString(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        iconColor: const Color(0xFF159447),
                        iconBackground: const Color(0xFFE5F7ED),
                        title: 'Completed',
                        value: completedOrders.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // RECENT ORDERS HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Orders',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Latest customer orders',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: widget.onViewAllOrders,
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 15),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ORDERS
                if (orderProvider.isLoading && recentOrders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 45),
                    child: Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  )
                else if (recentOrders.isEmpty)
                  const _EmptyOrdersCard()
                else
                  ...recentOrders.map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),

                      child: _RecentOrderCard(
                        orderId: order.id,
                        status: order.status,
                        itemCount: order.items.fold(
                          0,
                          (sum, item) => sum + item.quantity,
                        ),
                        total: order.total,
                        statusBackground: _getStatusBackground(order.status),
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
      height: 122,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: const Color(0xFFEDE9E5)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            height: 38,
            width: 38,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(icon, color: iconColor, size: 21),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7069),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2926),
            ),
          ),
        ],
      ),
    );
  }
}

// RECENT ORDER CARD

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
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: const Color(0xFFEDE9E5)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // ORDER ICON
          Container(
            height: 46,
            width: 46,

            decoration: BoxDecoration(
              color: const Color(0xFFFFEFE5),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFD35400),
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          // ORDER INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  '#ORD-${orderId.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2926),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7069),
                  ),
                ),
              ],
            ),
          ),

          // PRICE + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                'Rs. ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2926),
                ),
              ),

              const SizedBox(height: 7),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),

                    const SizedBox(width: 4),

                    Text(
                      _formatStatus(status),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
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

// EMPTY ORDERS

class _EmptyOrdersCard extends StatelessWidget {
  const _EmptyOrdersCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: const Color(0xFFEDE9E5)),
      ),

      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 45, color: Color(0xFFC9C0B9)),

          SizedBox(height: 12),

          Text(
            'No Recent Orders',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2926),
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Orders will appear here when customers place them.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF8A817B)),
          ),
        ],
      ),
    );
  }
}
