import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.finalPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': product.id,
      'productId': product.id,
      'name': product.name,
      'quantity': quantity,
      'price': product.finalPrice,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'] ?? 1,
    );
  }
}
