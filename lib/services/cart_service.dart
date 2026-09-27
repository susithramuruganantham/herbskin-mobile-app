import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => _items.fold(0.0, (total, item) => total + item.totalPrice);

  // Delivery fee rules matching backend:
  // Subtotal >= ₹500 is FREE delivery, otherwise ₹40
  double get deliveryFee => subtotal >= 500 || _items.isEmpty ? 0.0 : 40.0;

  double get grandTotal => subtotal + deliveryFee;

  bool get isFreeDelivery => subtotal >= 500;
  double get amountNeededForFreeDelivery => subtotal < 500 ? (500 - subtotal) : 0;

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(existingIndex);
      } else {
        _items[existingIndex].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderPayload() {
    return _items.map((item) => {
      'id': item.product.id,
      'productId': item.product.id,
      'name': item.product.name,
      'quantity': item.quantity,
      'unit_price': item.product.finalPrice,
    }).toList();
  }
}
