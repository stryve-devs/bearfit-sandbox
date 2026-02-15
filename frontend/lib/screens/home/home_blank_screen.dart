import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../widgets/workout/bottom_nav.dart';

class HomeBlankScreen extends StatefulWidget {
  const HomeBlankScreen({super.key});

  @override
  State<HomeBlankScreen> createState() => _HomeBlankScreenState();
}

class _HomeBlankScreenState extends State<HomeBlankScreen> {
  int navIndex = 0; // Home active

  void _onNavTap(int i) {
    setState(() => navIndex = i);
    if (i == 1) {
      Navigator.pushNamed(context, '/workout');
    } else if (i == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: const SizedBox.shrink(), // blank content
      bottomNavigationBar: WorkoutBottomNav(index: navIndex, onTap: _onNavTap),
    );
  }
}