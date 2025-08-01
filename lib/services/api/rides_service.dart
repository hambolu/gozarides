import 'api_client.dart';

class RidesService {
  final ApiClient _apiClient;

  RidesService(this._apiClient);

  Future<Map<String, dynamic>> requestRide({
    required Map<String, dynamic> pickupLocation,
    required Map<String, dynamic> dropoffLocation,
    required String paymentMethod,
    required String vehicleType,
  }) async {
    final response = await _apiClient.post('rides', {
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'payment_method': paymentMethod,
      'vehicle_type': vehicleType,
    });

    return response;
  }

  Future<Map<String, dynamic>> getActiveRide() async {
    final response = await _apiClient.get('rides/active');
    return response;
  }

  Future<void> cancelRide(String id, String reason) async {
    await _apiClient.post('rides/$id/cancel', {
      'reason': reason,
    });
  }
}
