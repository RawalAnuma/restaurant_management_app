import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  UserModel? _user;
  bool _isLoading = false;
  String? _token;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.post('/login', {
        'email': email,
        'password': password,
      });

      _token = response['token'];
      debugPrint('LOGIN TOKEN: $_token');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      //debugPrint('Token: $_token');

      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      _token = response['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await apiService.post('/logout', {});
    } catch (e) {
      debugPrint('Logout API error: $e');
    } finally {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('token');

      _token = null;
      _user = null;

      notifyListeners();
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final response = await apiService.get('/user');

      _user = UserModel.fromJson(response);

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching current user: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') != null;
  }
}
