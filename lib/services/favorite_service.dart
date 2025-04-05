import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/favorite_model.dart';
import '../models/crypto_model.dart';

class FavoriteService {
  final String baseUrl = 'https://zypto-pulse.directus.app';
  final storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    final token = await storage.read(key: 'access_token');
    print('Token from secure storage: $token'); // Debug print
    return token;
  }

  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/items/crypto_favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> items = data['data'] ?? [];
        return items.map((item) => FavoriteModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  Future<void> addFavorite(CryptoModel crypto) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/items/crypto_favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(crypto.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/items/crypto_favorites/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
