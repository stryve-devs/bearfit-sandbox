import 'package:flutter/material.dart';

class SelectTimerSoundPage extends StatelessWidget {
  const SelectTimerSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Select Timer Sound',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Timer Sound Options',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
