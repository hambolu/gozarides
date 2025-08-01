import 'api_client.dart';
import '../../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  void setToken(String token) {
    _apiClient.setToken(token);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String userType,
  }) async {
    // Format phone number to ensure it starts with +
    final formattedPhone = phone.startsWith('+') ? phone : '+$phone';
    
    final response = await _apiClient.post('register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': formattedPhone,
      'user_type': userType,
    });

    if (response['token'] != null) {
      _apiClient.setToken(response['token']);
    }

    return response;
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _apiClient.post('verify-otp', {
      'phone': phone,
      'otp': otp,
    });

    if (response['token'] != null) {
      _apiClient.setToken(response['token']);
    }

    return response;
  }

  Future<Map<String, dynamic>> resendOtp({
    required String phone,
  }) async {
    return await _apiClient.post('resend-otp', {
      'phone': phone,
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('login', {
      'email': email,
      'password': password,
    });

    if (response['token'] != null) {
      _apiClient.setToken(response['token']);
    }

    return response;
  }

  Future<void> logout() async {
    await _apiClient.post('logout', {});
    _apiClient.clearToken();
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get('user');
    final userData = response['data']['user'];
    
    return UserModel(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      phone: userData['phone'],
      type: userData['type'],
      profilePhotoUrl: userData['profile_photo_url'],
      emailVerifiedAt: userData['email_verified_at'] != null 
        ? DateTime.parse(userData['email_verified_at'])
        : null,
      isAdmin: userData['is_admin'],
      isDriver: userData['is_driver'],
      isActive: userData['is_active'],
      driverVerifiedAt: userData['driver_verified_at'] != null 
        ? DateTime.parse(userData['driver_verified_at'])
        : null,
      wallet: userData['wallet'],
      createdAt: DateTime.parse(userData['created_at']),
      updatedAt: DateTime.parse(userData['updated_at']),
    );
  }
}
