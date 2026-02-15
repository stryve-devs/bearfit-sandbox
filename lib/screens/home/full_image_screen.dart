import 'package:flutter/material.dart';
import '../../widgets/bf_bottom_nav.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }
}
