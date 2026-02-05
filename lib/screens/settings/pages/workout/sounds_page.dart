import 'package:flutter/material.dart';

class SoundsPage extends StatelessWidget {
  const SoundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Sounds',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: const [
          _SoundTile(title: 'Timer Sound'),
          _SoundTile(title: 'Timer Volume'),
          _SoundTile(title: 'Check Set'),
          _SoundTile(title: 'Live Personal Record Volume'),
        ],
      ),
    );
  }
}

class _SoundTile extends StatelessWidget {
  final String title;
  const _SoundTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.orange),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
    );
  }
}
