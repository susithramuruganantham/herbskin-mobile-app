class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] != null) ? (json['unit_price'] as num).toDouble() : 0.0,
      totalPrice: (json['total_price'] != null) ? (json['total_price'] as num).toDouble() : 0.0,
    );
  }
}

class ProductionBatch {
  final int id;
  final String batchNumber;
  final String status;
  final int targetQuantity;
  final String? qcInspector;
  final String? notes;

  ProductionBatch({
    required this.id,
    required this.batchNumber,
    required this.status,
    required this.targetQuantity,
    this.qcInspector,
    this.notes,
  });

  factory ProductionBatch.fromJson(Map<String, dynamic> json) {
    return ProductionBatch(
      id: json['id'] ?? 0,
      batchNumber: json['batch_number'] ?? '',
      status: json['status'] ?? '',
      targetQuantity: json['target_quantity'] ?? 0,
      qcInspector: json['qc_inspector'],
      notes: json['notes'],
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String deliveryAddress;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? notes;
  final String createdAt;
  final List<OrderItem> items;
  final List<ProductionBatch> batches;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.notes,
    required this.createdAt,
    this.items = const [],
    this.batches = const [],
  });

  static const List<String> statusSteps = [
    'ORDER_PLACED',
    'ORDER_CONFIRMED',
    'PRODUCTION_PLANNED',
    'IN_PRODUCTION',
    'QUALITY_CHECK',
    'PACKAGING',
    'SHIPPED',
    'DELIVERED'
  ];

  static String formatStatusLabel(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'ORDER_PLACED':
        return 'Order Placed';
      case 'ORDER_CONFIRMED':
        return 'Confirmed';
      case 'PRODUCTION_PLANNED':
        return 'AI Planned Batch';
      case 'IN_PRODUCTION':
        return 'In Production';
      case 'QUALITY_CHECK':
        return 'Quality Check (pH)';
      case 'PACKAGING':
        return 'Eco Packaging';
      case 'SHIPPED':
        return 'Shipped from Trichy';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return rawStatus.replaceAll('_', ' ');
    }
  }

  int get currentStepIndex {
    final idx = statusSteps.indexOf(orderStatus.toUpperCase());
    return idx != -1 ? idx : 0;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'];
    List<OrderItem> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
    }

    var rawBatches = json['batches'];
    List<ProductionBatch> parsedBatches = [];
    if (rawBatches is List) {
      parsedBatches = rawBatches.map((b) => ProductionBatch.fromJson(b as Map<String, dynamic>)).toList();
    }

    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      totalAmount: (json['total_amount'] != null) ? (json['total_amount'] as num).toDouble() : 0.0,
      paymentMethod: json['payment_method'] ?? 'Cash on Delivery',
      paymentStatus: json['payment_status'] ?? 'Pending',
      orderStatus: json['order_status'] ?? 'ORDER_PLACED',
      notes: json['notes'],
      createdAt: json['created_at'] ?? '',
      items: parsedItems,
      batches: parsedBatches,
    );
  }
}
