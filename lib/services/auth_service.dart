import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final http.Client _httpClient = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'https://zypto-pulse.directus.app';

  // Token storage keys
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Helper to handle API errors
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final errorData = json.decode(response.body);
      final errorMessage =
          errorData['errors']?[0]?['message'] ?? 'An error occurred';
      throw Exception(errorMessage);
    }
  }

  // Helper to create headers with authorization
  Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Sign in method
  Future<User> signIn({required String email, required String password}) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      _handleError(response);

      final responseData = json.decode(response.body);
      final accessToken = responseData['data']['access_token'];
      final refreshToken = responseData['data']['refresh_token'];

      // Store tokens
      await _storage.write(key: _tokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);

      // Get user data
      final userData = await getCurrentUser(accessToken);
      return userData;
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Sign up method
  Future<User> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      // First, create the user in Directus
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      _handleError(response);

      // After creating the user, log them in
      return await signIn(email: email, password: password);
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  // Get current user
  Future<User> getCurrentUser([String? token]) async {
    String? authToken = token;
    if (authToken == null) {
      authToken = await _storage.read(key: _tokenKey);
    }

    if (authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/users/me'),
        headers: _authHeaders(authToken),
      );

      if (response.statusCode == 401) {
        // Token expired, try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          return getCurrentUser();
        }
        throw Exception('Authentication expired');
      }

      _handleError(response);

      final responseData = json.decode(response.body);
      return User.fromJson(responseData['data'], token: authToken);
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Refresh token
  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) {
      return false;
    }

    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode >= 400) {
        await _storage.delete(key: _tokenKey);
        await _storage.delete(key: _refreshTokenKey);
        return false;
      }

      final responseData = json.decode(response.body);
      await _storage.write(
          key: _tokenKey, value: responseData['data']['access_token']);
      await _storage.write(
          key: _refreshTokenKey, value: responseData['data']['refresh_token']);
      return true;
    } catch (e) {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
      return false;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  // Sign out
  Future<void> signOut() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
