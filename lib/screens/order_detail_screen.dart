import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isUpdating = false;

  final Color primaryColor = const Color(0xFF5B3A29);
  final Color darkColor = const Color(0xFF3E2723);
  final Color backgroundColor = const Color(0xFFFFFBF7);
  final Color lightBrown = const Color(0xFFF5EDE6);

  final List<String> statuses = [
    'pending',
    'confirmed',
    'preparing',
    'ready',
    'completed',
    'cancelled',
  ];

  String _formatStatus(String status) {
    if (status.isEmpty) return status;

    return status[0].toUpperCase() + status.substring(1);
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

  String _formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    return '${parsedDate.day.toString().padLeft(2, '0')}/'
        '${parsedDate.month.toString().padLeft(2, '0')}/'
        '${parsedDate.year} '
        '${parsedDate.hour.toString().padLeft(2, '0')}:'
        '${parsedDate.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updateStatus(String? newStatus) async {
    if (newStatus == null || newStatus == widget.order.status) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      await context.read<OrderProvider>().updateOrderStatus(
        orderId: widget.order.id,
        status: newStatus,
      );

      if (!mounted) return;

      setState(() {
        widget.order.status = newStatus;
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order status updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Order #${order.id}',
          style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          _buildOrderSummary(order),

          const SizedBox(height: 20),

          _buildSectionTitle('Order Status'),

          const SizedBox(height: 10),

          _buildStatusCard(order),

          const SizedBox(height: 24),

          _buildSectionTitle('Order Items'),

          const SizedBox(height: 10),

          if (order.items.isEmpty)
            _buildEmptyItems()
          else
            ...order.items.map((item) => _buildOrderItem(item)),

          const SizedBox(height: 20),

          _buildTotalCard(order),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Order Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _summaryRow(
            icon: Icons.tag,
            label: 'Order ID',
            value: '#${order.id}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: _formatDate(order.createdAt),
          ),

          const SizedBox(height: 12),

          _summaryRow(
            icon: Icons.shopping_bag_outlined,
            label: 'Items',
            value: '${order.items.length}',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),

        const SizedBox(width: 10),

        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),

        const Spacer(),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: darkColor,
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatusCard(OrderModel order) {
    final statusColor = _statusColor(order.status);

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: _statusBackground(order.status),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(Icons.sync_alt, color: statusColor, size: 22),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Current Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ),

          if (_isUpdating)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF5B3A29),
              ),
            )
          else
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: statuses.contains(order.status) ? order.status : null,

                borderRadius: BorderRadius.circular(12),

                items: statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      _formatStatus(status),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),

                onChanged: _updateStatus,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    final subtotal = item.price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
      ),

      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: lightBrown,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(Icons.restaurant, color: primaryColor, size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: darkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Rs. ${item.price.toStringAsFixed(2)} × ${item.quantity}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            'Rs. ${subtotal.toStringAsFixed(2)}',
            style: TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: lightBrown,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Text(
            'Total Amount',
            style: TextStyle(
              color: darkColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          Text(
            'Rs. ${order.total.toStringAsFixed(2)}',
            style: TextStyle(
              color: primaryColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyItems() {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
      ),

      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 40,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 10),

          Text(
            'No items in this order',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
