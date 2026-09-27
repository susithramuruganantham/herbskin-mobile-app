import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/api_constants.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import 'auth_screen.dart';
import 'order_tracking_screen.dart';
import 'feedback_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'My Account & Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Card or Guest Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: auth.isAuthenticated && user != null
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.brand100,
                          child: Text(
                            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brand800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.brand50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Customer Tier: Botanical Preferred',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.brand700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to HERBSKIN HEAVEN',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Sign in to sync your orders, track batches, and access tailored AI routines.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        CustomButton(
                          text: 'Sign In / Register',
                          icon: Icons.login_rounded,
                          height: 44,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // Quick Actions Group
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.timeline_rounded, color: AppColors.brand700),
                    title: const Text('Live Order Tracking', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Track formulation, quality check & dispatch', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  ListTile(
                    leading: const Icon(Icons.rate_review_outlined, color: AppColors.accent),
                    title: const Text('Give Feedback to Founder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Direct line to ${ApiConstants.ownerEmail}', style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hub Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Manufacturing & Hub Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_city_outlined, size: 16, color: AppColors.brand700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ApiConstants.hubLocation,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 16, color: AppColors.brand700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ApiConstants.ownerEmail,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.eco_outlined, size: 16, color: AppColors.brand700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cold Process • Paraben Free • GMP Certified',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button if authenticated
            if (auth.isAuthenticated)
              CustomButton(
                text: 'Sign Out',
                isOutlined: true,
                textColor: AppColors.danger,
                icon: Icons.logout_rounded,
                onPressed: () => auth.logout(),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
