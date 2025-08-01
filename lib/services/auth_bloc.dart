import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api_services.dart';
import 'api/api_client.dart'; // Import for ApiException
import '../models/user_model.dart';

class AuthBloc extends ChangeNotifier {
  final _api = ApiServices();
  bool _isLoading = false;
  UserModel? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      _api.auth.setToken(_token!);
      try {
        await _loadUserProfile();
      } catch (e) {
        await logout();
      }
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.auth.login(
        email: email,
        password: password,
      );

      print('\n==========================================');
      print('📥 LOGIN RESPONSE');
      print('==========================================');
      print('Response: $response');
      print('==========================================\n');

      if (response['status'] != 'success') {
        throw ApiException(
          message: response['message'] ?? 'Login failed',
          statusCode: 400,
        );
      }

      _token = response['data']['token'];
      _api.auth.setToken(_token!); // Set token on API client
      await _saveToken();
      await _loadUserProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String userType,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.auth.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        userType: userType,
      );

      _token = response['token'];
      _api.auth.setToken(_token!); // Set token on API client
      await _saveToken();
      await _loadUserProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.auth.verifyOtp(
        phone: phone,
        otp: otp,
      );

      _token = response['token'];
      _api.auth.setToken(_token!); // Set token on API client
      await _saveToken();
      await _loadUserProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp({
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.auth.resendOtp(phone: phone);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _api.auth.logout();
      }
    } finally {
      _token = null;
      _currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      _currentUser = await _api.auth.getProfile();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveToken() async {
    if (_token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
    }
  }
}
