import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/order.dart';

class OrderStepperWidget extends StatelessWidget {
  final Order order;

  const OrderStepperWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currentIdx = order.currentStepIndex;

    final stepsInfo = [
      {'title': 'Order Placed', 'desc': 'Received by Trichy Hub', 'icon': Icons.shopping_bag_outlined},
      {'title': 'Order Confirmed', 'desc': 'Inventory verified', 'icon': Icons.check_circle_outline},
      {'title': 'AI Planned Batch', 'desc': 'Formula scaled & raw materials reserved', 'icon': Icons.precision_manufacturing_outlined},
      {'title': 'In Compounding', 'desc': 'Handcrafted formulation in progress', 'icon': Icons.science_outlined},
      {'title': 'Quality Check (pH)', 'desc': 'Laboratory pH & microbial assay', 'icon': Icons.verified_outlined},
      {'title': 'Eco Packaging', 'desc': 'Sterile bottling & labeling', 'icon': Icons.inventory_2_outlined},
      {'title': 'Shipped', 'desc': 'Dispatched via courier', 'icon': Icons.local_shipping_outlined},
      {'title': 'Delivered', 'desc': 'Arrived at your doorstep', 'icon': Icons.home_outlined},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stepsInfo.length,
      itemBuilder: (context, index) {
        final isPassed = index <= currentIdx;
        final isCurrent = index == currentIdx;
        final info = stepsInfo[index];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Line and Icon Indicator
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.brand600
                        : (isPassed ? AppColors.brand100 : AppColors.surfaceMuted),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPassed ? AppColors.brand600 : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      info['icon'] as IconData,
                      size: 18,
                      color: isCurrent
                          ? Colors.white
                          : (isPassed ? AppColors.brand700 : AppColors.textMuted),
                    ),
                  ),
                ),
                if (index < stepsInfo.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: index < currentIdx ? AppColors.brand600 : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Right Text Information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          info['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w700 : (isPassed ? FontWeight.w600 : FontWeight.w500),
                            color: isPassed ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.brand100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'CURRENT STATUS',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brand800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPassed ? AppColors.textSecondary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
