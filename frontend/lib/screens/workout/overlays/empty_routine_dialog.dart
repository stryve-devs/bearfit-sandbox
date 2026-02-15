import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';

class EmptyRoutineDialog extends StatelessWidget {
  final String message;
  const EmptyRoutineDialog({super.key, required this.message});

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
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center, style: WT.body(context, color: WorkoutColors.white)),
              const SizedBox(height: 8),
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
                        'Ok',
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