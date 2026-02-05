import 'package:flutter/material.dart';

class Home5FullImage extends StatelessWidget {
  final String imageUrl;

  const Home5FullImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Image (center)
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.broken_image,
                      color: Color(0xFFB0B0B0),
                      size: 50,
                    );
                  },
                ),
              ),
            ),

            // Close button (top-right)
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
