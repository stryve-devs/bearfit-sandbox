import 'package:flutter/material.dart';

class TimerVolumePage extends StatelessWidget {
  const TimerVolumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Timer Volume',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
