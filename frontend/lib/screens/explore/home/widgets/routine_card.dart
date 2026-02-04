// Routine card widget file
import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import 'exercise_tile.dart';

class RoutineCard extends StatelessWidget {
  final RoutineModel routine;

  const RoutineCard({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              routine.title,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.more_horiz, color: Colors.white),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            foregroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: const Text('Save Routine'),
        ),
        const SizedBox(height: 12),
        ...routine.exercises.map((e) => ExerciseTile(exercise: e)),
        const SizedBox(height: 30),
      ],
    );
  }
}
