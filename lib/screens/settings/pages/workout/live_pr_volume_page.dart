import 'package:flutter/material.dart';

class LivePRVolumePage extends StatelessWidget {
  const LivePRVolumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Live PR Volume',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
