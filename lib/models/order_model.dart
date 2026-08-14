class OrderModel {
  final int id;
  final double total;
  String status;
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
  final String? foodImage;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.foodImage,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final food = json['food'];
    final image = food?['image'];
    
    return OrderItemModel(
      id: json['id'],
      foodId: json['food_id'],
      foodName: json['food_name'] ?? json['food']?['name'] ?? 'Unknown Food',
      foodImage: image != null ? 'http://10.0.2.2:8000/storage/$image' : null,
      quantity: json['quantity'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    );
  }
}
