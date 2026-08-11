import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_management_app/utils/api_constants.dart';

class ApiService {
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode}');
  }
}
