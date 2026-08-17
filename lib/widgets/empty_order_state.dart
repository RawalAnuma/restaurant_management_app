import 'package:flutter/material.dart';

class EmptyOrderState extends StatelessWidget {
  final String selectedStatus;

  const EmptyOrderState({super.key, required this.selectedStatus});

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5EDE6),
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
                  selectedStatus == 'All'
                      ? 'There are no orders yet.'
                      : 'There are no $selectedStatus orders.',
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
