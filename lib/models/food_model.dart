class FoodModel {
  final int id;
  final String name;
  final double price;
  final int categoryId;

  FoodModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
    );
  }
}