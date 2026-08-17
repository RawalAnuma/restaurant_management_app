import 'package:flutter/material.dart';

class OrderStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final List<String> statuses;
  final ValueChanged<String> onStatusSelected;

  const OrderStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.statuses,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final selected = status == selectedStatus;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: selected,
              onSelected: (_) {
                onStatusSelected(status);
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
}
