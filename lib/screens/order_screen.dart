import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_app/screens/order_detail_screen.dart';

import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/empty_order_state.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_filter.dart';

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
            OrderStatusFilter(
              selectedStatus: _selectedStatus,
              statuses: _statuses,
              onStatusSelected: (status) {
                setState(() {
                  _selectedStatus = status;
                });
              },
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5B3A29),
                      ),
                    )
                  : orders.isEmpty
                  ? EmptyOrderState(selectedStatus: _selectedStatus)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderCard(
                          order: order,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailScreen(order: order),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
