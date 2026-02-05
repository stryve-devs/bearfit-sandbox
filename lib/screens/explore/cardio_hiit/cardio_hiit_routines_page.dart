// Cardio HIIT routines page file
import 'package:flutter/material.dart';

import './cardio_hiit_data.dart';
import '../widgets/routine_chip.dart';

class CardioHiitRoutinesPage extends StatelessWidget {
  const CardioHiitRoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0F08),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Cardio & HIIT Routines',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cardioHiitWorkouts.length,
        itemBuilder: (context, index) {
          final workout = cardioHiitWorkouts[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.title,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                workout.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Save Routine',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...workout.exercises.map(
                (exercise) => RoutineChip(
                  title: exercise.name,
                  sets: exercise.sets,
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
