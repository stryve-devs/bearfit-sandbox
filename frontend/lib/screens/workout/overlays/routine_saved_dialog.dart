import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';

class RoutineSavedDialog extends StatelessWidget {
  const RoutineSavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WorkoutColors.surface, // grey
      shape: const RoundedRectangleBorder(borderRadius: WRadii.pill),
      child: Container(
        decoration: const BoxDecoration(
          color: WorkoutColors.surface, // grey
          borderRadius: WRadii.pill,
          // No border
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Routine saved successfully!', textAlign: TextAlign.center, style: WT.title(context, color: WorkoutColors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: WRadii.pill,
                    onTap: () => Navigator.pop(context, 'start'),
                    child: Container(
                      height: 41,
                      decoration: const BoxDecoration(color: WorkoutColors.orange, borderRadius: WRadii.pill),
                      child: const Center(
                        child: Text(
                          'Start Workout',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    borderRadius: WRadii.pill,
                    onTap: () => Navigator.pop(context, 'close'),
                    child: Container(
                      height: 41,
                      decoration: const BoxDecoration(color: WorkoutColors.orange, borderRadius: WRadii.pill),
                      child: const Center(
                        child: Text(
                          'Close',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white),
                        ),
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