import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentUser != null;
  bool get isLoading => _isLoading;

  AuthService() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('hsh_customer_token');
    final userJson = prefs.getString('hsh_current_user');
    if (userJson != null) {
      try {
        _currentUser = User.fromJson(json.decode(userJson));
      } catch (e) {
        _currentUser = null;
      }
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        if (_token != null) await prefs.setString('hsh_customer_token', _token!);
        await prefs.setString('hsh_current_user', json.encode(_currentUser!.toJson()));

        _isLoading = false;
        notifyListeners();
        return {'success': true, 'message': data['message'] ?? 'Logged in successfully!'};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'error': data['error'] ?? 'Login failed. Check credentials.'};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Connection error. Please ensure backend is running.'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': fullName.trim(),
          'email': email.trim(),
          'password': password,
          'phone': phone?.trim() ?? '',
        }),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        if (_token != null) await prefs.setString('hsh_customer_token', _token!);
        await prefs.setString('hsh_current_user', json.encode(_currentUser!.toJson()));

        _isLoading = false;
        notifyListeners();
        return {'success': true, 'message': data['message'] ?? 'Account created successfully!'};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'error': data['error'] ?? 'Registration failed.'};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'error': 'Connection error. Please ensure backend is running.'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hsh_customer_token');
    await prefs.remove('hsh_current_user');
    notifyListeners();
  }
}
