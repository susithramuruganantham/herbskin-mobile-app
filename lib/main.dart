import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'constants/api_constants.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HerbSkinCustomerApp());
}

class HerbSkinCustomerApp extends StatelessWidget {
  const HerbSkinCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<CartService>(create: (_) => CartService()),
      ],
      child: MaterialApp(
        title: ApiConstants.storeName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brand600,
            primary: AppColors.brand600,
            secondary: AppColors.accent,
            surface: AppColors.surface,
            background: AppColors.background,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0.5,
            centerTitle: false,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
