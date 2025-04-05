// screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../widgets/crypto_favorites_card.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsyncValue = ref.watch(favoritesProvider);

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
      body: favoritesAsyncValue.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites added yet',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return CryptoFavoritesCard(
                favorite: favorite,
                onRemove: () async {
                  final favoriteService = ref.read(favoriteServiceProvider);
                  await favoriteService.removeFavorite(favorite.id);
                  ref.refresh(favoritesProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Favorite removed')),
                  );
                },
                onTap: () async {
                  final favoriteService = ref.read(favoriteServiceProvider);
                  await favoriteService.removeFavorite(favorite.id);
                  ref.refresh(favoritesProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Favorite removed')),
                  );
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
        currentIndex: 3,
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
          if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
