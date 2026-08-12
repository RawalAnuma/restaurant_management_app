import 'package:flutter/foundation.dart';

import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get('/orders');

      final List data = response['data'];

      _orders = data.map((order) => OrderModel.fromJson(order)).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    await apiService.patch('/orders/$orderId/status', {'status': status});

    await fetchOrders();
  }
}
