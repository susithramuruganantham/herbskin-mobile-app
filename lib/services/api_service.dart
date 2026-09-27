import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/product.dart';
import '../models/order.dart';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('hsh_customer_token');
  }

  static Future<Map<String, String>> _headers({bool needsAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (needsAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // 1. Fetch Products
  static Future<List<Product>> fetchProducts({String? category, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(uri, headers: await _headers()).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['products'] is List) {
          return (data['products'] as List).map((p) => Product.fromJson(p)).toList();
        }
      }
      return [];
    } catch (e) {
      // Return empty list or throw
      return [];
    }
  }

  // 2. Fetch Categories
  static Future<List<String>> fetchCategories() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}');
      final response = await http.get(uri, headers: await _headers()).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['categories'] is List) {
          final List<String> list = (data['categories'] as List).map((c) => c.toString()).toList();
          return ['All', ...list];
        }
      }
      return ['All', 'Shampoo', 'Soap', 'Face Wash', 'Hair Oil', 'Face Powder', 'Cream'];
    } catch (e) {
      return ['All', 'Shampoo', 'Soap', 'Face Wash', 'Hair Oil', 'Face Powder', 'Cream'];
    }
  }

  // 3. Create Order
  static Future<Map<String, dynamic>> createOrder({
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required String deliveryAddress,
    required List<Map<String, dynamic>> items,
    String paymentMethod = 'Cash on Delivery',
    String notes = '',
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersEndpoint}');
      final body = json.encode({
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail ?? '',
        'delivery_address': deliveryAddress,
        'payment_method': paymentMethod,
        'notes': notes,
        'items': items,
      });

      final response = await http.post(uri, headers: await _headers(), body: body).timeout(const Duration(seconds: 15));
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Network error: Please check server connectivity.'};
    }
  }

  // 4. Track Order
  static Future<Map<String, dynamic>> trackOrder(String query) async {
    try {
      final cleanQuery = Uri.encodeComponent(query.trim());
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.trackOrderEndpoint}/$cleanQuery');
      final response = await http.get(uri, headers: await _headers()).timeout(const Duration(seconds: 10));
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Failed to track order: $e'};
    }
  }

  // 5. Submit Customer Feedback
  static Future<Map<String, dynamic>> submitFeedback({
    required String name,
    required String email,
    String? phone,
    required int rating,
    required String category,
    required String message,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.feedbackEndpoint}');
      final body = json.encode({
        'customer_name': name,
        'customer_email': email,
        'customer_phone': phone ?? '',
        'rating': rating,
        'category': category,
        'message': message,
      });

      final response = await http.post(uri, headers: await _headers(), body: body).timeout(const Duration(seconds: 10));
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Feedback submission failed.'};
    }
  }
}
