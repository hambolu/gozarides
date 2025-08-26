import 'api_client.dart';
import '../../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

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
    
    DateTime? parseTimestamp(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is Map) return (value as Timestamp).toDate();
      return null;
    }
    
    return UserModel(
      uid: userData['uid'] ?? '',
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      userType: userData['userType'] ?? '',
      isPhoneVerified: userData['isPhoneVerified'] ?? false,
      isEmailVerified: userData['isEmailVerified'] ?? false,
      isActive: userData['isActive'] ?? true,
      profilePicture: userData['profilePicture'] ?? '',
      profileCompleted: userData['profileCompleted'] ?? false,
      rating: (userData['rating'] as num?)?.toDouble() ?? 0.0,
      totalRides: (userData['totalRides'] as num?)?.toInt() ?? 0,
      wallet: userData['wallet'],
      createdAt: parseTimestamp(userData['createdAt']) ?? DateTime.now(),
      updatedAt: parseTimestamp(userData['updatedAt']) ?? DateTime.now(),
    );
  }
}
