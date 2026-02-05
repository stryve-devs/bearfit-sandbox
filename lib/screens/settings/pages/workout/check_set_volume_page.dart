import 'package:flutter/material.dart';

class CheckSetVolumePage extends StatelessWidget {
  const CheckSetVolumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Check Set Volume',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
