import 'api_client.dart';

class PaymentsService {
  final ApiClient _apiClient;

  PaymentsService(this._apiClient);

  Future<Map<String, dynamic>> initializePayment({
    required String rideId,
    required double amount,
    required String paymentMethod,
  }) async {
    final response = await _apiClient.post('payments/initialize', {
      'ride_id': rideId,
      'amount': amount,
      'payment_method': paymentMethod,
    });

    return response;
  }

  Future<Map<String, dynamic>> verifyPayment(String reference) async {
    final response = await _apiClient.get('payments/verify/$reference');
    return response;
  }
}

class WalletService {
  final ApiClient _apiClient;

  WalletService(this._apiClient);

  Future<Map<String, dynamic>> getBalance() async {
    final response = await _apiClient.get('wallet/balance');
    return response;
  }

  Future<Map<String, dynamic>> addFunds({
    required double amount,
    required String paymentMethod,
    required String cardToken,
  }) async {
    final response = await _apiClient.post('wallet/add-funds', {
      'amount': amount,
      'payment_method': paymentMethod,
      'card_token': cardToken,
    });

    return response;
  }

  Future<Map<String, dynamic>> withdrawFunds({
    required double amount,
    required String bankCode,
    required String accountNumber,
  }) async {
    final response = await _apiClient.post('wallet/withdraw', {
      'amount': amount,
      'bank_code': bankCode,
      'account_number': accountNumber,
    });

    return response;
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final response = await _apiClient.get('wallet/transactions');
    return List<Map<String, dynamic>>.from(response['transactions']);
  }
}
