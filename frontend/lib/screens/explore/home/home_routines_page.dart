import 'package:flutter/material.dart';
import 'data/home_routines_data.dart';
import 'widgets/routine_card.dart';

class HomeRoutinesPage extends StatelessWidget {
  const HomeRoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'At Home Routines',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: homeRoutines.length,
        itemBuilder: (context, index) {
          return RoutineCard(routine: homeRoutines[index]);
        },
      ),
    );
  }
}
