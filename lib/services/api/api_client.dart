import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ApiClient {
  static const String baseUrl = 'https://app.gozarides.com/api/v1';
  String? _token;

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    developer.log('GET Request to: $url');
    developer.log('Headers: ${_getHeaders()}');

    final response = await http.get(
      url,
      headers: _getHeaders(),
    );
    _logResponse(response);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      print('\n==========================================');
      print('🌐 API REQUEST');
      print('==========================================');
      print('Endpoint: $endpoint');
      print('Payload: $data');
      print('==========================================\n');

      final url = Uri.parse('$baseUrl/$endpoint');
      developer.log('POST Request to: $url');
      developer.log('Headers: ${_getHeaders()}');
      developer.log('Body: ${jsonEncode(data)}');

      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(data),
      );

      print('\n==========================================');
      print('📥 API RESPONSE');
      print('==========================================');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('==========================================\n');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        print('\n==========================================');
        print('❌ API ERROR DETAILS');
        print('==========================================');
        print('Status Code: ${response.statusCode}');
        print('Error Body: $errorBody');
        print('==========================================\n');
        
        throw ApiException(
          message: errorBody['message'] ?? 'An error occurred',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('\n==========================================');
      print('❌ API REQUEST FAILED');
      print('==========================================');
      print('Error: $e');
      print('==========================================\n');
      
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to connect to server',
        statusCode: 500,
      );
    }
  }

  void _logResponse(http.Response response) {
    developer.log('Response Status Code: ${response.statusCode}');
    developer.log('Response Body: ${response.body}');
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Headers: ${response.headers}');
    print('API Response Body: ${response.body}');

    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      // For validation errors (422) format the response in the standardized format
      if (response.statusCode == 422) {
        final errors = body['errors'] ?? {};
        final standardError = {
          'status': 'error',
          'message': 'Validation failed',
          'data': {
            'errors': errors
          }
        };
        print('Validation Error: ${jsonEncode(standardError)}');
        throw ApiException(
          message: 'Validation failed',
          statusCode: response.statusCode,
          errors: standardError,
        );
      }

      throw ApiException(
        message: body['message'] ?? 'Something went wrong',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message, 
    required this.statusCode, 
    this.errors,
  });

  bool get isValidationError => statusCode == 422;

  Map<String, dynamic> toJson() => errors ?? {
    'status': 'error',
    'message': message,
    'data': {'errors': {}}
  };

  @override
  String toString() => message;
}
