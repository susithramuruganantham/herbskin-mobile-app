import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/order_stepper.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? initialOrderNumber;

  const OrderTrackingScreen({super.key, this.initialOrderNumber});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final _searchController = TextEditingController();
  Order? _trackedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialOrderNumber != null && widget.initialOrderNumber!.isNotEmpty) {
      _searchController.text = widget.initialOrderNumber!;
      _trackOrder(widget.initialOrderNumber!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _trackOrder([String? query]) async {
    final q = query ?? _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _errorMessage = 'Please enter an Order ID (e.g. HSH-10293) or Mobile Number.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.trackOrder(q);

    setState(() => _isLoading = false);

    if (res['success'] == true && res['order'] != null) {
      setState(() {
        _trackedOrder = Order.fromJson(res['order']);
      });
    } else {
      setState(() {
        _trackedOrder = null;
        _errorMessage = res['error'] ?? 'No active order found matching this query.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'Live Order Tracking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Manufacturing & Delivery',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your Order ID (e.g. HSH-10293) or 10-digit customer phone number.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'e.g. HSH-10293 or 9876543210',
                            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                            filled: true,
                            fillColor: AppColors.surfaceMuted,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (val) => _trackOrder(val),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brand600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : () => _trackOrder(),
                        child: _isLoading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.search, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

            // Tracking Result
            if (_trackedOrder != null) ...[
              const SizedBox(height: 8),
              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _trackedOrder!.orderNumber,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brand900),
                            ),
                            Text(
                              'Customer: ${_trackedOrder!.customerName}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.brand100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            Order.formatStatusLabel(_trackedOrder!.orderStatus),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.brand800),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.border),

                    // 8-Step Timeline Stepper
                    const Text(
                      'Live Manufacturing & Fulfillment Stepper',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    OrderStepperWidget(order: _trackedOrder!),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Itemized Breakdown Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ordered Botanical Items',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    ..._trackedOrder!.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.productName}', style: const TextStyle(fontSize: 13)),
                              Text('₹${item.totalPrice.toInt()}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        )),
                    const Divider(height: 20, color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.w700)),
                        Text('₹${_trackedOrder!.totalAmount.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.brand800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
