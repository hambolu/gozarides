import 'api_client.dart';

class SearchService {
  final ApiClient _apiClient;

  SearchService(this._apiClient);

  Future<List<Map<String, dynamic>>> searchDrivers({
    required double latitude,
    required double longitude,
    required String vehicleType,
  }) async {
    final response = await _apiClient.post('search/drivers', {
      'latitude': latitude,
      'longitude': longitude,
      'vehicle_type': vehicleType,
    });

    return List<Map<String, dynamic>>.from(response['drivers']);
  }

  Future<Map<String, dynamic>> estimateRide({
    required Map<String, dynamic> pickup,
    required Map<String, dynamic> dropoff,
    required String vehicleType,
  }) async {
    final response = await _apiClient.post('search/rides/estimate', {
      'pickup': pickup,
      'dropoff': dropoff,
      'vehicle_type': vehicleType,
    });

    return response;
  }
}
