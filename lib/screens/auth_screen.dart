import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsRegister;

  const AuthScreen({super.key, this.initialIsRegister = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isRegister;
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);
    //final auth = Provider.read<AuthService>(context);
    final auth = Provider.of<AuthService>(context, listen: false);

    if (_isRegister) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _errorMessage = 'Passwords do not match.');
        return;
      }

      final res = await auth.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );

      if (res['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() => _errorMessage = res['error']);
      }
    } else {
      final res = await auth.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (res['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() => _errorMessage = res['error']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.watch<AuthService>(context);
      final auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          _isRegister ? 'Create Account' : 'Customer Sign In',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header logo / title
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.brand50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.spa_rounded, color: AppColors.brand700, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isRegister ? 'Join HERBSKIN HEAVEN' : 'Welcome Back',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.brand900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pure Botanical Skincare & Personalized Routines',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tab Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isRegister = false;
                          _errorMessage = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isRegister ? AppColors.brand600 : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: !_isRegister ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isRegister = true;
                          _errorMessage = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isRegister ? AppColors.brand600 : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: _isRegister ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Error alert
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Form fields
              if (_isRegister) ...[
                CustomTextField(
                  label: 'Full Name *',
                  hint: 'e.g. Priya Sundaram',
                  controller: _fullNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Email Address *',
                  hint: 'e.g. priya@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Phone Number (Optional)',
                  hint: 'e.g. 9876543210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 14),
              ] else ...[
                CustomTextField(
                  label: 'Email or Username *',
                  hint: 'Enter your email or username',
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter your username/email' : null,
                ),
                const SizedBox(height: 14),
              ],

              // Password
              CustomTextField(
                label: 'Password *',
                hint: 'Minimum 4 characters',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) => (v == null || v.length < 4) ? 'Password must be at least 4 characters' : null,
              ),
              const SizedBox(height: 14),

              // Confirm Password for registration
              if (_isRegister) ...[
                CustomTextField(
                  label: 'Confirm Password *',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_clock_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please confirm your password' : null,
                ),
                const SizedBox(height: 14),
              ],

              const SizedBox(height: 10),
              CustomButton(
                text: _isRegister ? 'Create Account' : 'Sign In',
                isLoading: auth.isLoading,
                icon: _isRegister ? Icons.person_add_outlined : Icons.login_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
