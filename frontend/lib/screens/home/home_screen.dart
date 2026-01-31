import 'package:flutter/material.dart';
import '../../widgets/themed_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: ThemedText('Welcome to the Flutter frontend'),
      ),
    );
  }
}
