import 'package:flutter/material.dart';
import '../models/crypto_model.dart';

class CryptoCard extends StatelessWidget {
  final CryptoModel crypto;
  final VoidCallback onFavoriteToggle;

  const CryptoCard({
    Key? key,
    required this.crypto,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.priceChangePercentage24h >= 0;
    final priceColor = isPositive ? const Color(0xFF40E49E) : Colors.red;
    final priceChangeText = isPositive
        ? '+${crypto.priceChangePercentage24h.toStringAsFixed(2)}%'
        : '${crypto.priceChangePercentage24h.toStringAsFixed(2)}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Crypto icon
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(crypto.imageUrl),
          ),
          const SizedBox(width: 12),

          // Main Content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 350;

                return Row(
                  children: [
                    // Name and Symbol
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crypto.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isCompact ? 14 : 16,
                            ),
                          ),
                          Text(
                            crypto.symbol.toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isCompact ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chart
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SizedBox(
                          width: isCompact ? 40 : 50,
                          height: isCompact ? 24 : 30,
                          child: CustomPaint(
                            painter: ChartPainter(isPositive: isPositive),
                          ),
                        ),
                      ),
                    ),

                    // Price & Change
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${crypto.currentPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isCompact ? 14 : 16,
                            ),
                          ),
                          Text(
                            priceChangeText,
                            style: TextStyle(
                              color: priceColor,
                              fontSize: isCompact ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Favorite icon
          IconButton(
            icon: Icon(
              crypto.isFavorite ? Icons.star : Icons.star_border,
              color: crypto.isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final bool isPositive;

  ChartPainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? const Color(0xFF40E49E) : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (isPositive) {
      // Draw upward trend
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.5,
          size.width * 0.4, size.height * 0.7);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.9,
          size.width * 0.8, size.height * 0.4);
      path.lineTo(size.width, size.height * 0.2);
    } else {
      // Draw downward trend
      path.moveTo(0, size.height * 0.2);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.5,
          size.width * 0.4, size.height * 0.3);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.1,
          size.width * 0.8, size.height * 0.6);
      path.lineTo(size.width, size.height * 0.8);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
