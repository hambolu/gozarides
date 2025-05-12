import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/account_type_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/order_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoZarides',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
        ),
        textTheme: AppTypography.textTheme,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/account-type': (context) => const AccountTypeScreen(),
        '/signup': (context) => SignupScreen(
              accountType: (ModalRoute.of(context)?.settings.arguments as String?) ?? 'rider',
            ),
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/otp-verification': (context) => OtpVerificationScreen(
              phoneNumber: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/home': (context) => const HomeScreen(),
        '/order-details': (context) => OrderDetailsScreen(
              orderId: ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}
