import 'package:flutter/material.dart';
import 'settings/settings_page.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SettingsPage(),
    );
  }
}
