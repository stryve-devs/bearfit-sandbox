import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../widgets/workout/bottom_nav.dart';

class ProfileBlankScreen extends StatefulWidget {
  const ProfileBlankScreen({super.key});

  @override
  State<ProfileBlankScreen> createState() => _ProfileBlankScreenState();
}

class _ProfileBlankScreenState extends State<ProfileBlankScreen> {
  int navIndex = 2; // Profile active

  void _onNavTap(int i) {
    setState(() => navIndex = i);
    if (i == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (i == 1) {
      Navigator.pushNamed(context, '/workout');
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