// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../widgets/crypto_card.dart';
import '../models/favorite_model.dart';
import '../screens/favorites_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptosAsyncValue = ref.watch(cryptoListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121828),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0x1B232A), // Your AppBar background
            boxShadow: [
              BoxShadow(
                color: Color(0x80161C22), // #161C22 at 50% opacity
                offset: Offset(0, 12),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12), // Optional spacing
              child: GestureDetector(
                onTap: () {
                  // Handle profile tap
                  print("Profile avatar tapped");
                },
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/wow.png'),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Image.asset('assets/icons/search.png',
                    width: 44, height: 44),
                onPressed: () {},
              ),
              IconButton(
                icon:
                    Image.asset('assets/icons/scan.png', width: 44, height: 44),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('assets/icons/notif.png',
                    width: 44, height: 44),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: cryptosAsyncValue.when(
        data: (cryptos) {
          return ListView.builder(
            itemCount: cryptos.length,
            itemBuilder: (context, index) {
              final crypto = cryptos[index];
              return CryptoCard(
                crypto: crypto,
                onFavoriteToggle: () async {
                  final favoriteService = ref.read(favoriteServiceProvider);
                  if (crypto.isFavorite) {
                    // Find favorite ID and remove
                    final favorites = await ref.read(favoritesProvider.future);
                    final favorite =
                        favorites.firstWhere((f) => f.name == crypto.id,
                            orElse: () => FavoriteModel(
                                  id: '',
                                  name: '',
                                  symbol: '',
                                  currentPrice: 0,
                                  marketCapRank: '',
                                  priceChangePercentage24h: 0,
                                  imageUrl: '',
                                ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favorite added')),
                    );
                    if (favorite.id.isNotEmpty) {
                      await favoriteService.removeFavorite(favorite.id);
                    }
                  } else {
                    // Add to favorites
                    await favoriteService.addFavorite(crypto);
                  }
                  // Refresh providers
                  ref.refresh(favoritesProvider);
                },
              );
            },
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF40E49E))),
        error: (error, stack) => Center(
            child: Text('Error: $error',
                style: const TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121828),
        selectedItemColor: const Color(0xFF40E49E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 44, height: 44),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/markets.png', width: 44, height: 44),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/trades.png', width: 44, height: 44),
            label: 'Trades',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/favourites.png',
                width: 44, height: 44),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/wallets.png', width: 44, height: 44),
            label: 'Wallets',
          ),
        ],
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavoritesScreen()));
          }
        },
      ),
    );
  }
}
