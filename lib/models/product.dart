class Product {
  final int id;
  final String productCode;
  final String name;
  final String category;
  final String description;
  final String size;
  final String unit;
  final double price;
  final double discount;
  final double finalPrice;
  final int stockFinished;
  final int minimumStock;
  final String benefits;
  final String ingredientsSummary;
  final String usageInstructions;
  final String manufacturingInfo;
  final String batchNumber;
  final String expiryPeriod;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final bool isActive;

  Product({
    required this.id,
    required this.productCode,
    required this.name,
    required this.category,
    required this.description,
    required this.size,
    required this.unit,
    required this.price,
    required this.discount,
    required this.finalPrice,
    required this.stockFinished,
    required this.minimumStock,
    required this.benefits,
    required this.ingredientsSummary,
    required this.usageInstructions,
    required this.manufacturingInfo,
    required this.batchNumber,
    required this.expiryPeriod,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.isActive,
  });

  bool get inStock => stockFinished > 0;
  bool get lowStock => stockFinished > 0 && stockFinished <= minimumStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productCode: json['product_code'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      size: json['size']?.toString() ?? '100',
      unit: json['unit'] ?? 'ml',
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
      discount: (json['discount'] != null) ? (json['discount'] as num).toDouble() : 0.0,
      finalPrice: (json['final_price'] != null) ? (json['final_price'] as num).toDouble() : 0.0,
      stockFinished: json['stock_finished'] ?? 0,
      minimumStock: json['minimum_stock'] ?? 0,
      benefits: json['benefits'] ?? '',
      ingredientsSummary: json['ingredients_summary'] ?? '',
      usageInstructions: json['usage_instructions'] ?? '',
      manufacturingInfo: json['manufacturing_info'] ?? 'HerbSkin Heaven Central Unit, Palpannai, Trichy-8',
      batchNumber: json['batch_number'] ?? '',
      expiryPeriod: json['expiry_period'] ?? '24 months from MFG',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 5.0,
      reviewsCount: json['reviews_count'] ?? 0,
      imageUrl: json['image_url'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_code': productCode,
      'name': name,
      'category': category,
      'description': description,
      'size': size,
      'unit': unit,
      'price': price,
      'discount': discount,
      'final_price': finalPrice,
      'stock_finished': stockFinished,
      'minimum_stock': minimumStock,
      'benefits': benefits,
      'ingredients_summary': ingredientsSummary,
      'usage_instructions': usageInstructions,
      'manufacturing_info': manufacturingInfo,
      'batch_number': batchNumber,
      'expiry_period': expiryPeriod,
      'rating': rating,
      'reviews_count': reviewsCount,
      'image_url': imageUrl,
      'is_active': isActive ? 1 : 0,
    };
  }
}
