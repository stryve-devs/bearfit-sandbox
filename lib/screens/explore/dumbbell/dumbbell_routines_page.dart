// Dumbbell routines page file
import 'package:flutter/material.dart';
import 'data/dumbbell_routines_data.dart';
import '../home/widgets/routine_card.dart';

class DumbbellRoutinesPage extends StatelessWidget {
  const DumbbellRoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Dumbbell Only Routines',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dumbbellRoutines.length,
        itemBuilder: (context, index) {
          return RoutineCard(
            routine: dumbbellRoutines[index],
          );
        },
      ),
    );
  }
}
