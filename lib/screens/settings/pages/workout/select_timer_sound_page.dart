import 'package:flutter/material.dart';

class SelectTimerSoundPage extends StatelessWidget {
  final String initialValue;

  const SelectTimerSoundPage({super.key, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    final options = [
      "Default",
      "Alarm",
      "Futuristic",
      "Ting Ting",
      "Boxing Bell",
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text("Select Timer Sound",
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
