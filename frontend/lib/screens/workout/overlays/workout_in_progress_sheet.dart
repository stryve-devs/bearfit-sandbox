import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_sizes.dart';
import '../../../constants/workout_typography.dart';

class WorkoutInProgressSheet extends StatelessWidget {
  const WorkoutInProgressSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: WorkoutColors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: WorkoutColors.orange, width: 1.5),
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 80, height: 5, decoration: BoxDecoration(color: WorkoutColors.orange, borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 16),
            Text('Workout in progress', style: WT.body(context)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => Navigator.pop(context, 'Resume'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Center(child: Text('Resume', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => Navigator.pop(context, 'Discard'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Center(child: Text('Discard', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}