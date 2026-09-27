class SuggestedItem {
  final int id;
  final String name;
  final int quantity;
  final double price;

  SuggestedItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory SuggestedItem.fromJson(Map<String, dynamic> json) {
    return SuggestedItem(
      id: json['id'] ?? json['productId'] ?? 0,
      name: json['name'] ?? json['productName'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<SuggestedItem>? suggestedCartItems;
  final String? actionType;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestedCartItems,
    this.actionType,
  });
}
