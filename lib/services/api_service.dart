import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CryptoModel>> getCryptoList() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<CryptoModel> cryptoList =
            data.map((crypto) => CryptoModel.fromJson(crypto)).toList();
        return cryptoList;
      } else {
        throw Exception('Failed to load crypto data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch crypto data: $e');
    }
  }
}
