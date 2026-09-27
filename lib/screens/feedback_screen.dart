import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  int _rating = 5;
  String _category = 'Product Experience';
  bool _isLoading = false;

  final List<String> _feedbackCategories = [
    'Product Experience',
    'Packaging & Aroma',
    'Delivery Speed',
    'Customer Support',
    'Ingredient Suggestion',
  ];

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
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final res = await ApiService.submitFeedback(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      rating: _rating,
      category: _category,
      message: _messageController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      if (!mounted) return;
      _messageController.clear();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.mark_email_read_rounded, color: AppColors.brand600),
              SizedBox(width: 8),
              Text('Feedback Dispatched!', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(
            'Thank you! Your feedback & rating have been delivered directly to the founder at ${ApiConstants.ownerEmail}.',
            style: const TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(color: AppColors.brand700, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error'] ?? 'Submission failed.')),
      );
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
          'Customer Feedback & Review',
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
              // Notice banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.brand50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.brand100),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.email_outlined, color: AppColors.brand800, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All reviews and suggestions are directly monitored by the founder at rpandimeenacsc@gmail.com.',
                        style: TextStyle(fontSize: 12, color: AppColors.brand900, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Form Container
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
                    // Rating Star Picker
                    const Text(
                      'Rate Your Experience',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return IconButton(
                          icon: Icon(
                            starValue <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 36,
                          ),
                          onPressed: () => setState(() => _rating = starValue),
                        );
                      }),
                    ),
                    Center(
                      child: Text(
                        '$_rating / 5 Stars',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                      ),
                    ),
                    const Divider(height: 24, color: AppColors.border),

                    // Category Dropdown
                    const Text(
                      'Feedback Topic',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      items: _feedbackCategories.map((c) {
                        return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Name
                    CustomTextField(
                      label: 'Your Name *',
                      hint: 'e.g. Anand Kumar',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 14),

                    // Email
                    CustomTextField(
                      label: 'Your Email *',
                      hint: 'e.g. anand@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 14),

                    // Phone
                    CustomTextField(
                      label: 'Phone (Optional)',
                      hint: 'e.g. 9876543210',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 14),

                    // Message
                    CustomTextField(
                      label: 'Your Review or Botanical Suggestion *',
                      hint: 'Tell us how the product felt on your hair/skin, aroma satisfaction, etc.',
                      controller: _messageController,
                      maxLines: 4,
                      validator: (v) => (v == null || v.isEmpty) ? 'Please write your feedback' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Submit to Founder',
                isLoading: _isLoading,
                icon: Icons.send_rounded,
                onPressed: _submitFeedback,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
