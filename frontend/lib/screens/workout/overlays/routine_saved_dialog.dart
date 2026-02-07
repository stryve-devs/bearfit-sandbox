import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';

class RoutineSavedDialog extends StatelessWidget {
  const RoutineSavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WorkoutColors.black,
      shape: const RoundedRectangleBorder(borderRadius: WRadii.pill),
      child: Container(
        decoration: BoxDecoration(
          color: WorkoutColors.black,
          borderRadius: WRadii.pill,
          border: Border.all(color: WorkoutColors.orange, width: 1.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Routine saved successfully!', textAlign: TextAlign.center, style: WT.title(context)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => Navigator.pop(context, 'start'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Center(child: Text('Start Workout', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange))),
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
                      onTap: () => Navigator.pop(context, 'close'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Center(child: Text('Close', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange))),
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