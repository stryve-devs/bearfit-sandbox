import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../utils/figma_sizer.dart';
import '../../constants/workout_sizes.dart';

class FilterChipPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const FilterChipPill({super.key, required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = FigmaSizer.of(context);
    final color = WorkoutColors.orange; // same color for now

    return Material(
      color: WorkoutColors.surface,
      borderRadius: WRadii.pill, // BorderRadius constant
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: s.fw(24), vertical: s.fh(14)),
          child: Text(label, style: WT.h2(context, color: color)), // use typography
        ),
      ),
    );
  }
}