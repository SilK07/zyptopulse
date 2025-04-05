class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final String imageUrl;
  final int marketCapRank;
  final double priceChangePercentage24h;
  final bool isFavorite;

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.imageUrl,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
    this.isFavorite = false,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      currentPrice: json['current_price']?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
      marketCapRank: json['market_cap_rank'] ?? 0,
      priceChangePercentage24h:
          json['price_change_percentage_24h']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': id,
      'symbol': symbol.toLowerCase(),
      'current_price': currentPrice,
      'market_cap_rank': marketCapRank.toString(),
      'price_change_percentage_24h': priceChangePercentage24h,
      'image_url': imageUrl,
    };
  }
}
