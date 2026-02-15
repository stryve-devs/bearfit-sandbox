import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final EdgeInsets padding;

  const PillButton({
    super.key,
    required this.label,
    this.onTap,
    this.bg = WorkoutColors.surface,
    this.fg = WorkoutColors.orange,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: WRadii.pill,
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Center(child: Text(label, style: WT.h2(context, color: fg))),
        ),
      ),
    );
  }
}