import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_management_app/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    debugPrint('TOKEN FROM STORAGE: $token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> logout(String endpoint) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: await _headers(),
    );

    debugPrint('LOGOUT STATUS: ${response.statusCode}');
    debugPrint('LOGOUT RESPONSE: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception('Logout failed: ${response.statusCode} ${response.body}');
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode}${response.body}');
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode}');
  }

  Future<dynamic> postMultipart(
    String endpoint,
    Map<String, String> fields, {
    File? image,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
    );

    final headers = await _headers();

    // MultipartRequest sets its own Content-Type.
    headers.remove('Content-Type');

    request.headers.addAll(headers);
    request.fields.addAll(fields);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode} ${response.body}');
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    debugPrint('PUT URL: $url');
    debugPrint('PUT DATA: $data');

    final response = await http.put(
      url,
      headers: await _headers(),
      body: jsonEncode(data),
    );

    debugPrint('PUT STATUS: ${response.statusCode}');
    debugPrint('PUT RESPONSE: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode} ${response.body}');
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode}');
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception('Request failed: ${response.statusCode}');
  }
}
