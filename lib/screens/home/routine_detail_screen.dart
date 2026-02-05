import 'package:flutter/material.dart';

class RoutineDetailScreen extends StatelessWidget {
  final String title;

  const RoutineDetailScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => "Exercise ${i + 1} • 3 sets");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(color: Color(0xFF1A1A1A)),
        itemBuilder: (_, i) => ListTile(
          title: Text(items[i], style: const TextStyle(color: Colors.white)),
          subtitle: const Text("Tap to open (demo)", style: TextStyle(color: Color(0xFFB0B0B0))),
        ),
      ),
    );
  }
}
