import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/workout_colors.dart';
import '../../widgets/workout/custom_header.dart';

class SettingsBlankScreen extends StatelessWidget {
  const SettingsBlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with only a back arrow
            CustomHeader(
              left: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/icons/arrow_back.svg',
                  height: 18,
                  colorFilter: const ColorFilter.mode(WorkoutColors.orange, BlendMode.srcIn),
                ),
              ),
              center: const SizedBox.shrink(), // no title
              right: const SizedBox.shrink(),  // no action
            ),
            const Expanded(
              child: SizedBox.shrink(), // blank content area
            ),
          ],
        ),
      ),
    );
  }
}