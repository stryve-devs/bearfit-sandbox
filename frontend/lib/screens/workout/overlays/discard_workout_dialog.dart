import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';

class DiscardWorkoutDialog extends StatelessWidget {
  const DiscardWorkoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WorkoutColors.surface, // grey
      shape: const RoundedRectangleBorder(borderRadius: WRadii.pill),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 337),
        child: Container(
          decoration: const BoxDecoration(
            color: WorkoutColors.surface, // grey
            borderRadius: WRadii.pill,
            // No border
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to discard your workout?',
                textAlign: TextAlign.center,
                style: WT.body(context, color: WorkoutColors.white),
              ),
              const SizedBox(height: 20),
              Material(
                color: WorkoutColors.orange, // orange button
                borderRadius: WRadii.pill,
                child: InkWell(
                  borderRadius: WRadii.pill,
                  onTap: () => Navigator.pop(context, true),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Center(
                      child: Text(
                        'Discard',
                        style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: WorkoutColors.orange, // orange button
                borderRadius: WRadii.pill,
                child: InkWell(
                  borderRadius: WRadii.pill,
                  onTap: () => Navigator.pop(context, false),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}