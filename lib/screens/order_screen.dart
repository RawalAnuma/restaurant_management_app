import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/screens/create_order_screen.dart';
import 'package:restaurant_management_app/screens/order_detail_screen.dart';

import '../providers/order_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Text('No orders found', style: TextStyle(fontSize: 18)),
            );
          }

          return RefreshIndicator(
            onRefresh: orderProvider.fetchOrders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${order.id}')),
                    title: Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${order.items.length} item(s)'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(order.status.toUpperCase()),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final orderProvider = context.read<OrderProvider>();

          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
          );

          if (created == true && mounted) {
            orderProvider.fetchOrders();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
    );
  }
}
