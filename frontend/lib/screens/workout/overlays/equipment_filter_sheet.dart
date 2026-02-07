import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';
import '../../../data/repositories/exercise_repository.dart';

class EquipmentFilterSheet extends StatelessWidget {
  const EquipmentFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ExerciseRepository.equipmentList;
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
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Material(
                  color: WorkoutColors.surface,
                  borderRadius: WRadii.pill,
                  child: InkWell(
                    borderRadius: WRadii.pill,
                    onTap: () => Navigator.pop(context, items[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Align(alignment: Alignment.centerLeft, child: Text(items[i], style: WT.h2(context, color: WorkoutColors.orange))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}