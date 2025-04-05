import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crypto_model.dart';
import '../models/favorite_model.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final favoriteServiceProvider =
    Provider<FavoriteService>((ref) => FavoriteService());

final cryptoListProvider = FutureProvider<List<CryptoModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCryptoList();
});

final favoritesProvider = FutureProvider<List<FavoriteModel>>((ref) async {
  final favoriteService = ref.watch(favoriteServiceProvider);
  return favoriteService.getFavorites();
});
