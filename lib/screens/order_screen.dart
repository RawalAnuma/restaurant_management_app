import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/screens/order_detail_screen.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedStatus = 'All';

  final List<String> _statuses = [
    'All',
    'Pending',
    'Confirmed',
    'Preparing',
    'Ready',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<OrderProvider>().fetchOrders();
    });
  }

  List<OrderModel> _filteredOrders(List<OrderModel> orders) {
    if (_selectedStatus == 'All') {
      return orders;
    }

    final status = _selectedStatus.toLowerCase();

    return orders.where((order) => order.status == status).toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD97706);

      case 'confirmed':
        return const Color(0xFF2563EB);

      case 'preparing':
        return const Color(0xFF7C3AED);

      case 'ready':
        return const Color(0xFF059669);

      case 'completed':
        return const Color(0xFF15803D);

      case 'cancelled':
        return const Color(0xFFDC2626);

      default:
        return Colors.grey;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFF7ED);

      case 'confirmed':
        return const Color(0xFFEFF6FF);

      case 'preparing':
        return const Color(0xFFF5F3FF);

      case 'ready':
        return const Color(0xFFECFDF5);

      case 'completed':
        return const Color(0xFFF0FDF4);

      case 'cancelled':
        return const Color(0xFFFEF2F2);

      default:
        return Colors.grey.shade100;
    }
  }

  String _formatStatus(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    return '${parsedDate.day.toString().padLeft(2, '0')}/'
        '${parsedDate.month.toString().padLeft(2, '0')}/'
        '${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final orders = _filteredOrders(provider.orders);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF7),
        elevation: 0,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF5B3A29),
        onRefresh: provider.fetchOrders,
        child: Column(
          children: [
            _buildStatusFilter(),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5B3A29),
                      ),
                    )
                  : orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(orders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statuses.length,
        itemBuilder: (context, index) {
          final status = _statuses[index];
          final selected = status == _selectedStatus;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selectedStatus = status;
                });
              },
              selectedColor: const Color(0xFF5B3A29),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF5B3A29),
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: selected
                    ? const Color(0xFF5B3A29)
                    : Colors.brown.shade100,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _statusColor(order.status);
    final statusBackground = _statusBackground(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.brown.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDE6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFF5B3A29),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(order.createdAt),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatStatus(order.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(height: 1),

              const SizedBox(height: 14),

              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const Spacer(),

                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Rs. ${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF5B3A29),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Icon(Icons.chevron_right, color: Color(0xFF5B3A29)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDE6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    size: 52,
                    color: Color(0xFF5B3A29),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No orders found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedStatus == 'All'
                      ? 'There are no orders yet.'
                      : 'There are no $_selectedStatus orders.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
