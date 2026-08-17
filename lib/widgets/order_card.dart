import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

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
        return const Color(0xFFF5F5F5);
    }
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return status;

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
        onTap: onTap,
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
                    '${order.items.length} '
                    'item${order.items.length == 1 ? '' : 's'}',
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
}
