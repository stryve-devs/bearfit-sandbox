import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';

class CustomHeader extends StatelessWidget {
  final Widget left;
  final Widget center;
  final Widget right;
  final Color backgroundColor;

  const CustomHeader({
    super.key,
    required this.left,
    required this.center,
    required this.right,
    this.backgroundColor = WorkoutColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Align(alignment: Alignment.centerLeft, child: left)),
          Expanded(child: Center(child: center)),
          Expanded(child: Align(alignment: Alignment.centerRight, child: right)),
        ],
      ),
    );
  }
}