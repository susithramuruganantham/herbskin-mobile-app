import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthService>();
      if (auth.currentUser != null) {
        _nameController.text = auth.currentUser!.fullName;
        _emailController.text = auth.currentUser!.email;
        if (auth.currentUser!.phone != null) {
          _phoneController.text = auth.currentUser!.phone!;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartService = context.read<CartService>();
    if (cartService.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.createOrder(
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerEmail: _emailController.text.trim(),
      deliveryAddress: _addressController.text.trim(),
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim(),
      items: cartService.toOrderPayload(),
    );

    setState(() => _isLoading = false);

    if (result['success'] == true && result['order'] != null) {
      final orderData = result['order'];
      final orderNum = orderData['order_number'] ?? '';

      // Clear cart
      cartService.clearCart();

      if (!mounted) return;

      // Show Order Confirmation Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.brand100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.brand700, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Order Placed Successfully!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Order Number: $orderNum',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brand800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our AI Production Planner has analyzed and scheduled compounding batches at the Palpannai Hub.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Track Order Live',
                icon: Icons.timeline_rounded,
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(initialOrderNumber: orderNum),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Order failed. Please try again.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'Checkout & Delivery',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact & Delivery Section
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
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: AppColors.brand700, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Shipping Address',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: AppColors.border),
                    CustomTextField(
                      label: 'Full Name *',
                      hint: 'e.g. Priya Sundaram',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Phone Number *',
                      hint: 'e.g. 9876543210',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter your mobile number' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Email Address (For Order Updates)',
                      hint: 'e.g. priya@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Complete Street Address *',
                      hint: 'Door No, Street Name, Landmark, City, Pincode',
                      controller: _addressController,
                      maxLines: 2,
                      prefixIcon: Icons.home_outlined,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter your full delivery address' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Special Delivery Instructions (Optional)',
                      hint: 'e.g. Leave with security, call before arrival',
                      controller: _notesController,
                      prefixIcon: Icons.notes_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method Selector
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
                    const Row(
                      children: [
                        Icon(Icons.payment_outlined, color: AppColors.brand700, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Payment Option',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: AppColors.border),
                    RadioListTile<String>(
                      title: const Text('Cash on Delivery (COD)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Pay with cash or UPI at delivery doorstep', style: TextStyle(fontSize: 12)),
                      value: 'Cash on Delivery',
                      groupValue: _paymentMethod,
                      activeColor: AppColors.brand600,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('UPI / Google Pay / PhonePe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Fast & direct payment via Indian UPI rails', style: TextStyle(fontSize: 12)),
                      value: 'UPI',
                      groupValue: _paymentMethod,
                      activeColor: AppColors.brand600,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Total Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brand50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.brand100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount Payable', style: TextStyle(fontSize: 12, color: AppColors.brand900)),
                        Text(
                          '₹${cartService.grandTotal.toInt()}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.brand800),
                        ),
                      ],
                    ),
                    Text(
                      '${cartService.itemCount} items',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brand700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomButton(
                text: 'Confirm & Place Order',
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
                onPressed: _submitOrder,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
