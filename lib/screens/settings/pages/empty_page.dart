import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String title;

  const EmptyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: const SizedBox(),
    );
  }
}
