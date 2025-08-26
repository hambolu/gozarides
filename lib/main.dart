import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/order_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/home/home_screen.dart';
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
import 'screens/order/order_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    // Use debug provider for development, switch to playIntegrity for production
    androidProvider: AndroidProvider.debug,
    // appleProvider is only needed if you're building for iOS
    appleProvider: AppleProvider.deviceCheck,
  );
  
  // Request notification permissions
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'GozaRides',
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
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/account-type': (context) => const AccountTypeScreen(),
          '/signup': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            return SignupScreen(
              accountType: (args?['accountType'] as String?) ?? 'buyer',
            );
          },
          '/login': (context) => const LoginScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/reset-password': (context) => ResetPasswordScreen(
                email: ModalRoute.of(context)?.settings.arguments as String,
              ),
          '/otp-verification': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
            return OtpVerificationScreen(
              phoneNumber: args['phoneNumber']!,
              verificationId: args['verificationId']!,
            );
          },
          '/home': (context) => const HomeScreen(),
          '/order-details': (context) => OrderDetailsScreen(
                orderId: ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
