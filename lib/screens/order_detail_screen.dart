import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/providers/order_provider.dart';

import '../models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  DropdownButton<String>(
                    value: order.status,
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'preparing',
                        child: Text('Preparing'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                      DropdownMenuItem(
                        value: 'cancelled',
                        child: Text('Cancelled'),
                      ),
                    ],
                    onChanged: _isUpdating
                        ? null
                        : (newStatus) async {
                            if (newStatus == null ||
                                newStatus == order.status) {
                              return;
                            }

                            setState(() {
                              _isUpdating = true;
                            });

                            try {
                              await context
                                  .read<OrderProvider>()
                                  .updateOrderStatus(
                                    orderId: order.id,
                                    status: newStatus,
                                  );

                              if (!mounted) return;

                              // Update the UI immediately.
                              setState(() {
                                order.status = newStatus;
                                _isUpdating = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order status updated'),
                                ),
                              );

                              // Give the user a moment to see the update.
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );

                              if (!mounted) return;

                              Navigator.of(context).pop(true);
                            } catch (e) {
                              if (!mounted) return;

                              setState(() {
                                _isUpdating = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update status: $e'),
                                ),
                              );
                            }
                          },
                  ),

                  if (_isUpdating)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Order Items',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          ...order.items.map(
            (item) => Card(
              child: ListTile(
                title: Text(
                  item.foodName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Rs. ${item.price.toStringAsFixed(2)} × ${item.quantity}',
                ),
                trailing: Text(
                  'Rs. ${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rs. ${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
