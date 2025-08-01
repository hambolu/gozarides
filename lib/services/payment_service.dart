import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/wallet/paystack_webview.dart';

class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService);

  Future<Map<String, dynamic>> initializePayment({
    required BuildContext context,
    required double amount,
    required String paymentMethod,
    Map<String, dynamic>? paymentDetails,
    String callbackUrl = 'gozarides://payment-callback',
  }) async {
    try {
      final response = await _apiService.post(
        '/wallet/topup',
        data: {
          'amount': amount,
          'payment_method': paymentMethod,
          'payment_details': paymentDetails ?? {},
          'callback_url': callbackUrl,
        },
      );

      if (response['data']['authorization_url'] != null) {
        final authorizationUrl = response['data']['authorization_url'];
        final reference = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => PaystackWebView(
              authorizationUrl: authorizationUrl,
              callbackUrl: callbackUrl,
              onComplete: (reference) {
                Navigator.pop(context, reference);
              },
            ),
          ),
        );

        if (reference != null) {
          // Verify the payment
          final verificationResponse = await _apiService.get('/wallet/verify/$reference');
          return verificationResponse['data'];
        }
      }

      return response['data'];
    } catch (e) {
      throw Exception('Failed to initialize payment: $e');
    }
  }
}
