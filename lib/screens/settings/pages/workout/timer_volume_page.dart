import 'package:flutter/material.dart';

class TimerVolumePage extends StatelessWidget {
  final String initialValue;

  const TimerVolumePage({super.key, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    final options = ["High", "Normal", "Low", "Off"];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text("Timer Sound Volume",
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: options.map((e) {
          return ListTile(
            title: Text(e,
                style: const TextStyle(color: Colors.orange)),
            trailing: initialValue == e
                ? const Icon(Icons.check, color: Colors.orange)
                : null,
            onTap: () {
              Navigator.pop(context, e);
            },
          );
        }).toList(),
      ),
    );
  }
}
