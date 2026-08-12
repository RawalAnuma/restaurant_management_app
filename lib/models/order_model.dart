class OrderModel {
  final int id;
  final double total;
  final String status;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      total: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      status: json['status'],
      createdAt: json['created_at'],
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int id;
  final int foodId;
  final String foodName;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      foodId: json['food_id'],
      foodName: json['food_name'] ?? json['food']?['name'] ?? 'Unknown Food',
      quantity: json['quantity'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    );
  }
}
