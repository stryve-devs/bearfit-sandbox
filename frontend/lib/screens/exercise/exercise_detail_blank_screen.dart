import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';

class ExerciseDetailBlankScreen extends StatelessWidget {
  const ExerciseDetailBlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final title = (arg is String && arg.isNotEmpty) ? arg : 'Exercise Detail';

    return Scaffold(
      backgroundColor: WorkoutColors.black,
      appBar: AppBar(
        backgroundColor: WorkoutColors.black,
        title: Text(title, style: const TextStyle(fontFamily: 'Quicksand')),
      ),
      body: const Center(
        child: Text(
          'Exercise detail placeholder',
          style: TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.orange),
        ),
      ),
    );
  }
}