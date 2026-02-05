import 'package:flutter/material.dart';
import './data/gym_routines_data.dart';
import '../home/widgets/routine_card.dart';

class GymRoutinesPage extends StatelessWidget {
  const GymRoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Gym Routines',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gymRoutines.length,
        itemBuilder: (context, index) {
          return RoutineCard(routine: gymRoutines[index]);
        },
      ),
    );
  }
}
