import 'package:flutter/material.dart';

import './band_data.dart';
import '../widgets/routine_chip.dart';

class BandRoutinesPage extends StatelessWidget {
  const BandRoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0F08),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Band Routines',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bandWorkouts.length,
        itemBuilder: (context, index) {
          final workout = bandWorkouts[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔶 TITLE
              Text(
                workout.title,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // 📄 DESCRIPTION
              Text(
                workout.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 12),

              // 💾 SAVE BUTTON
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

              // 🏋️ EXERCISES
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
