import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';

class CryptoFavoritesCard extends StatelessWidget {
  final FavoriteModel favorite;
  final VoidCallback onRemove;
  final VoidCallback? onTap; // Optional onTap for card click

  const CryptoFavoritesCard({
    Key? key,
    required this.favorite,
    required this.onRemove,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = favorite.priceChangePercentage24h >= 0;
    final priceColor = isPositive ? const Color(0xFF40E49E) : Colors.red;
    final priceChangeText = isPositive
        ? '+${favorite.priceChangePercentage24h.toStringAsFixed(2)}%'
        : '${favorite.priceChangePercentage24h.toStringAsFixed(2)}%';

    String formatIsoDate(String? isoDateString) {
      if (isoDateString == null) return 'Unknown date';
      try {
        DateTime dateTime = DateTime.parse(isoDateString).toLocal();
        return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } catch (e) {
        return 'Invalid date';
      }
    }

    final dateText = formatIsoDate(favorite.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.grey.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark card background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Crypto icon
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(favorite.imageUrl),
              ),
              const SizedBox(width: 16),

              // Crypto name and info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Symbol and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          favorite.symbol.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          dateText,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    // Market cap rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Market Cap Rank:',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${favorite.marketCapRank}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '\$${favorite.currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Price change 24h
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price Change (24h):',
                          style: TextStyle(
                            color: priceColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          priceChangeText,
                          style: TextStyle(
                            color: priceColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
