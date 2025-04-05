class FavoriteModel {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final String marketCapRank;
  final double priceChangePercentage24h;
  final String imageUrl;
  final String? userId;
  final String? createdAt;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
    required this.imageUrl,
    this.userId,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      currentPrice: double.tryParse(json['current_price'].toString()) ?? 0.0,
      marketCapRank: json['market_cap_rank'].toString(),
      priceChangePercentage24h:
          double.tryParse(json['price_change_percentage_24h'].toString()) ??
              0.0,
      imageUrl: json['image_url'] ?? '',
      userId: json['user_id'],
      createdAt: json['created_at'],
    );
  }
}
