import 'api_client.dart';

class OrdersService {
  final ApiClient _apiClient;

  OrdersService(this._apiClient);

  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> pickupLocation,
    required Map<String, dynamic> dropoffLocation,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
  }) async {
    final response = await _apiClient.post('orders', {
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'items': items,
      'payment_method': paymentMethod,
    });

    return response;
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await _apiClient.get('orders');
    return List<Map<String, dynamic>>.from(response['orders']);
  }

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final response = await _apiClient.get('orders/$orderId');
    return response;
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    await _apiClient.post('orders/$orderId/cancel', {
      'reason': reason,
    });
  }
}
