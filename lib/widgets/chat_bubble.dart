import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final timeStr = DateFormat('hh:mm a').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8, top: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.brand700,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.brand700 : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser ? null : Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: isUser ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser ? Colors.white70 : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Render suggested cart items if any
          if (!isUser && message.suggestedCartItems != null && message.suggestedCartItems!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.brand50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brand100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shopping_bag_rounded, size: 16, color: AppColors.brand800),
                      SizedBox(width: 6),
                      Text(
                        'AI Recommended Cart Items',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand800,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.brand100),
                  ...message.suggestedCartItems!.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.name}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '₹${(item.price * item.quantity).toInt()}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brand700),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () async {
                        final cartService = context.read<CartService>();
                        // Fetch all products to match ID and add to cart
                        final allProducts = await ApiService.fetchProducts();
                        for (final sItem in message.suggestedCartItems!) {
                          final match = allProducts.firstWhere(
                            (p) => p.id == sItem.id || p.name.toLowerCase().contains(sItem.name.toLowerCase()),
                            orElse: () => Product(
                              id: sItem.id,
                              productCode: 'HSH-AI',
                              name: sItem.name,
                              category: 'Herbal',
                              description: 'AI recommended botanical item',
                              size: '100',
                              unit: 'ml',
                              price: sItem.price,
                              discount: 0,
                              finalPrice: sItem.price,
                              stockFinished: 50,
                              minimumStock: 10,
                              benefits: 'Handcrafted botanical formulation',
                              ingredientsSummary: 'Organic herbal extracts',
                              usageInstructions: 'Apply daily',
                              manufacturingInfo: 'Palpannai, Trichy-8',
                              batchNumber: 'HSH-AI-2026',
                              expiryPeriod: '24 months',
                              rating: 5.0,
                              reviewsCount: 1,
                              imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80',
                              isActive: true,
                            ),
                          );
                          cartService.addItem(match, quantity: sItem.quantity);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('✨ Items added to your shopping bag!'),
                              backgroundColor: AppColors.brand700,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Add All to Cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
