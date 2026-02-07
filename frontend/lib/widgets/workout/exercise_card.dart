import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../utils/figma_sizer.dart';
import '../../constants/workout_sizes.dart';

class ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback? onTap;

  const ExerciseCard({super.key, required this.title, required this.subtitle, required this.imageAsset, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = FigmaSizer.of(context);

    return Material(
      color: WorkoutColors.surface,
      borderRadius: WRadii.pill,
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: s.fw(20), vertical: s.fh(16)),
          child: Row(
            children: [
              CircleAvatar(
                radius: s.fw(28),
                backgroundImage: AssetImage(imageAsset),
                backgroundColor: WorkoutColors.white.withOpacity(0.06),
              ),
              SizedBox(width: s.fw(16)),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: WT.title(context)),
                  SizedBox(height: s.fh(6)),
                  Text(subtitle, style: WT.body(context)),
                ]),
              ),
              Icon(Icons.arrow_forward, color: WorkoutColors.white, size: s.fs(22)),
            ],
          ),
        ),
      ),
    );
  }
}