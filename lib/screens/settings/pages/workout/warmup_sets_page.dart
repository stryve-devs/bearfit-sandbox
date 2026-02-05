import 'package:flutter/material.dart';

class WarmupSetsPage extends StatefulWidget {
  const WarmupSetsPage({super.key});

  @override
  State<WarmupSetsPage> createState() => _WarmupSetsPageState();
}

class _WarmupSetsPageState extends State<WarmupSetsPage> {
  bool includeWarmups = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title:
            const Text('Warm-up Sets', style: TextStyle(color: Colors.white)),
      ),
      body: SwitchListTile(
        activeThumbColor: Colors.orange,
        title: const Text(
          'Include warm-up sets in workout stats',
          style: TextStyle(color: Colors.orange),
        ),
        subtitle: Text(
          'Warm-up sets will count towards volume and PRs',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        value: includeWarmups,
        onChanged: (v) => setState(() => includeWarmups = v),
      ),
    );
  }
}
